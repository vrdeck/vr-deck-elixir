defmodule Result do
  @type t(data, msg) :: {:ok, data} | {:error, msg}
end
