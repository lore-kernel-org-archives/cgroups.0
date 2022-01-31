From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm/page_owner: Record task command name
Date: Mon, 31 Jan 2022 12:54:15 -0800
Message-ID: <YfhMd5LTzTHu9zMD@carbon.dhcp.thefacebook.com>
References: <20220131192308.608837-1-longman@redhat.com>
 <20220131192308.608837-5-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xyyEHXP2nW0NzwlhVNwOjjW4qZDXWl9phb79Ox+4rS0=;
 b=jT6c9H+1pdkY+OfRj0glhrPGxI1Vn/+ZDwzrB9MzPBiATPHNx6fC95Ejra1e5cRi3PoQ
 t3Qq+IKsuS7cdRafE5BAF+sYEMq8TmgkRxDNgD7XYjxYKC3a4T3pJZCVpeWU/EXkcGrg
 Hdr7hMrGVD9OPtnv/o9h+cYSRUoa8rGh9T4= 
Content-Disposition: inline
In-Reply-To: <20220131192308.608837-5-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 31, 2022 at 02:23:08PM -0500, Waiman Long wrote:
> The page_owner information currently includes the pid of the calling
> task. That is useful as long as the task is still running. Otherwise,
> the number is meaningless. To have more information about the allocating
> tasks that had exited by the time the page_owner information is
> retrieved, we need to store the command name of the task.
> 
> Add a new comm field into page_owner structure to store the command name
> and display it when the page_owner information is retrieved. Only the
> first 15 characters of the command name will be copied, but that should
> be enough in most cases. Even for those commands with longer names,
> it shouldn't be hard to guess what they are.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/page_owner.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index a471c74c7fe0..8b2b381fd986 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -20,6 +20,7 @@
>   * to use off stack temporal storage
>   */
>  #define PAGE_OWNER_STACK_DEPTH (16)
> +#define PAGE_OWNER_COMM_LEN	16

Not sure I understand why not simply use TASK_COMM_LEN ?
