From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: clarify cgroup_css_set_fork()
Date: Tue, 22 Feb 2022 07:39:41 -1000
Message-ID: <YhUf3QuwB9aHT60i@slm.duckdns.org>
References: <20220221151639.3828143-1-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3dt3gz8kjCoy+zOLuGXFrGoSXvvg7jhT72pRPC3cAmo=;
        b=CPCIZ08cqqxPYNocoFg/gQk550OLi0J1HgIIbzDPu4K3LBtAsnMcCU3fU5O8jraCte
         JC/aQ/phgl2NgereqZkj6ybN/iD0UOSZqRCAYploTleZ6pHDl0LELYc/R8iK9Q7gDhfh
         kzRVaLQ5JNK4LMgcJsQYuCUcMvDHj9AYs+UsenezC8i8gIZkbZ4m7tcvl7ficrC0S9pm
         WaFibbjPRIzZhoKishx/M5kqKQoK5Py4pjd7qYJ5ieQZ2wCQdtGsMo3LE9l7TAXfHQf+
         cEA5H7lMVhVYMVl68Dq2Mo3qs5+EfSNvWu4qMhSVCoXzAT0S6R4J1dOHBu5MmvwCauy1
         v6gA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220221151639.3828143-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 21, 2022 at 04:16:39PM +0100, Christian Brauner wrote:
> With recent fixes for the permission checking when moving a task into a cgroup
> using a file descriptor to a cgroup's cgroup.procs file and calling write() it
> seems a good idea to clarify CLONE_INTO_CGROUP permission checking with a
> comment.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to for-5.17-fixes with cosmetic changes.

Thakns.

-- 
tejun
