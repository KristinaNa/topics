defmodule DiscussWeb.TopicController do
    use DiscussWeb, :controller
    alias Discuss.Topic
  
    def index(conn, _params) do
        topics = Discuss.Repo.all(Topic)

        render conn, "index.html", topics: topics
    end

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})

        render conn, "new.html",  changeset: changeset
    end

    def create(conn, %{"topic" => topic}) do
        changeset = Topic.changeset(%Topic{}, topic)

        case Discuss.Repo.insert(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic created")
                |> redirect(to: Routes.topic_path(conn, :index))
            {:error, changeset} ->
                put_flash(conn, :error, "Something went wrong")
                render conn, "new.html", changeset: changeset
        end
    end

    def edit(conn, %{"id" => topic_id }) do        
        topic = Discuss.Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end

    def update(conn, %{ "id" => topic_id, "topic" => topic }) do
        old_topic = Discuss.Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic)

        case Discuss.Repo.update(changeset) do
            {:ok, _topic} -> 
                conn                
                |> put_flash(:info, "Topic updated")
                |> redirect(to: Routes.topic_path(conn, :index))
            {:error, changeset} -> 
                render conn, "edit.html", changeset: changeset, topic: old_topic
        end
    end

    def delete(conn, %{"id" => topic_id}) do
        Discuss.Repo.get!(Topic, topic_id) |> Discuss.Repo.delete!
    
        conn 
        |> put_flash(:info, "Topic deleted")
        |> redirect(to: Routes.topic_path(conn, :index))

        # render conn, "index.html", changeset: changeset
    end
  end
  