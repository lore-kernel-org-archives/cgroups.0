From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/51] memcg: add mem_cgroup_root_css
Date: Fri, 19 Jun 2015 11:17:19 -0400
Message-ID: <20150619151719.GI12934@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-7-git-send-email-tj@kernel.org>
 <20150617145642.GI25056@dhcp22.suse.cz>
 <20150617182500.GI22637@mtj.duckdns.org>
 <20150618111227.GA5858@dhcp22.suse.cz>
 <20150618174930.GA12934@mtj.duckdns.org>
 <20150619091848.GE4913@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gudwNeNXpjiXLYKQJ2prl76iaiwut45mlzPt3CXk+Mg=;
        b=XZaRw+b7YghU7qx02vqwWSBn/tuzh92G+LnNBsMAnDTJHRerhjazM/4AVBkzT1wQ/E
         WYFynpQYar0Bw7cMlYTfctB63imk76uazys3KTEgqKq3Zc7m0Cj56tbShxaEZlJhlRHp
         ZJAi10aDw0fWW++ZnaUURZIJaicG9XyRA6sELiZb4SQ8dgscAw+ncEYmtidt56C0R3aS
         lzRyYnhKPCYG6i6IjkEwVrvMNZvbRq9Kg1h4dyuuOZ5O9l87tG7Y0+mzg8xizzZCm15H
         RV45GoacMwjx9pVcyrhTiLpN0d+ACoNHHS6YIijGjTHzn+kcBwJTNGVSQewhpcAMhNKT
         XFhA==
Content-Disposition: inline
In-Reply-To: <20150619091848.GE4913-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri, Jun 19, 2015 at 11:18:48AM +0200, Michal Hocko wrote:
> On Thu 18-06-15 13:49:30, Tejun Heo wrote:
> [...]
> > > I have tried to compile with !CONFIG_MEMCG and !CONFIG_CGROUP_WRITEBACK
> > > without mem_cgroup_root_css defined for this configuration and
> > > mm/backing-dev.c compiles just fine. So maybe we should get rid of it
> > > rather than have a potentially tricky code?
> > 
> > Yeah, please feel free to queue a patch to remove it if doesn't break
> > anything.
> 
> Against which branch should a I generate the patch?

It's in the for-4.2/writeback branch of the block tree; however, a
patch against -mm should work, right?

Thanks.

-- 
tejun
