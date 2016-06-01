defmodule Server.StatusController do
  use Server.Web, :controller
  alias DB.Status

  def index(conn, %{"service" => service}) do
    IO.inspect service
    statuses = Status.all_updates(service)
    render conn, "index.html", statuses: statuses, service: String.upcase(service)
  end

  def show(conn, %{"id" => id, "service" => service}) do
    url = case service do
      "xbl" -> "http://support.xbox.com/"
      "psn" -> "https://status.playstation.com/"
    end

    page =
      Path.expand("html/#{id}.html")
      |> File.read!
      |> String.replace(~r{ href="/}, ~s{ href="#{url}})
      |> String.replace(~r{ src="/}, ~s{ src="#{url}})
      |> String.replace(~r{ src="\./}, ~s{ src="#{url}})

    html conn, page
  end
end
#
# page = """
# <h3 class="unavailable statusheading">
# <script type="text/javascript" charset="utf-8" async="" data-requirecontext="_" data-requiremodule="window" src="./window.js"></script>
#                         <img class="p-b-md p-r-md" src="/Content/Images/LiveStatus/unavailable_icon.png" alt="" title="" aria-label="">
#                         <span class="unavailable d-ib-lg d-n-s">Limited</span>
#                     </h3>
# """
# page
# |> String.replace(~r{ src="/}, ~s{ src="http://support.xbox.com/})
# |> String.replace(~r{ src="\./}, ~s{ src="http://support.xbox.com/})
