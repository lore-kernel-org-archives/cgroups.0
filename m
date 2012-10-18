From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] memcg: root_cgroup cannot reach
 mem_cgroup_move_parent
Date: Thu, 18 Oct 2012 14:58:07 -0700
Message-ID: <20121018215807.GO13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-3-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wRE42eXMU2vU/1HGj9MX8ZaxSBTMqbochMf2P65Q924=;
        b=B6Qkonn6BfevtEbRZPsuN230cYbr3SgKrHsPjUlzBayj5FW+/3HmXb7lGuEC/3O7OP
         G61YKiIZ2jF05Uh5clNSy4PGYUPuqiS/uBR+2WYTJUx2W76PzQuhkkKUeYMpvuaRVTmf
         wslqYPSe/GVzlY6JWw9hcStO4wX4QpEHiYQS7jgf3jRjW7vl036RrwWp2v81AaxvrlGC
         B7mNASD+UMVmw1glPDn95NI6bonKbfUfMhS2FvKEWjRJSVxiMuxAU6kXaksQQwbf2eFa
         6bWvZgLnUkPLQUV9EExs82HXW7EuOH/a3mr9uuDo0oCD+jkIfi1Nsx6xUTXINtfM4Imk
         336A==
Content-Disposition: inline
In-Reply-To: <1350480648-10905-3-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Oct 17, 2012 at 03:30:44PM +0200, Michal Hocko wrote:
> The root cgroup cannot be destroyed so we never hit it idown the
> mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
> even try to do anything if called for the root.
> 
> This means that mem_cgroup_move_parent doesn't have to bother with the
> root cgroup and it can assume it can always move charges upwards.
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
