From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Fri, 19 Oct 2012 13:17:36 -0700
Message-ID: <20121019201736.GQ13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <50811E5E.1090205@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RXGwCGy0eZuC3XKzo4P3ScIX5bwbLADIEXYpFsh8Bmk=;
        b=WN039gaeoyNY5u5oVqO8ueDzkALjrf6PSZrvPnvNoiu2ZYRZvzfVV4UKiS5HcW8hn5
         I9bGl4BsWzZzqSLpVH/MT9/UYY+r2HACvwjEfogn4Qr3WjWBDPac//YYmt2OTGOkfME2
         vCU8eWTu4pMDIgZWGj9FE6T3MQitt3n2YDFT3QH/yaU6lxpKB/n+aNQsrZuqx2yBDrZ0
         wF47rRFfEFs6eb/ChYJzV78Q/OJWf3L4uX7luroLBJfnEurfXlBRlfy7e7gfFLSSeO95
         KJm4LhqIQ9SBNuwPoZUe7PgOJCobvCOUoaYecQ3YH6nBGE0RK/G+f9STLiA4X3c/srk9
         JlpQ==
Content-Disposition: inline
In-Reply-To: <50811E5E.1090205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Oct 19, 2012 at 05:33:18PM +0800, Li Zefan wrote:
> On 2012/10/17 21:30, Michal Hocko wrote:
> > Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> > safely move on and forbit all the callbacks to fail. The last missing
> > piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> > that css_tryget fails so no new charges for the memcg can happen.
> 
> > The callbacks are also called from within cgroup_lock to guarantee that
> > no new tasks show up. 
> 
> I'm afraid this won't work. See commit 3fa59dfbc3b223f02c26593be69ce6fc9a940405
> ("cgroup: fix potential deadlock in pre_destroy")

Yeah, you're right.  Argh... we really should unexport cgroup_lock
soon.

Thanks.

-- 
tejun
