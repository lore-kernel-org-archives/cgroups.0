From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cpuset: drop cpuset->stack_list and ->parent, take#2
Date: Mon, 7 Jan 2013 08:52:29 -0800
Message-ID: <20130107165229.GJ3926@htj.dyndns.org>
References: <1357249446-25075-1-git-send-email-tj@kernel.org>
 <50E94392.2050509@huawei.com>
 <20130107164707.GI3926@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=8nVEUsdIl9lPBLFEP/cu1Od4ugeZUIPk1vesiLVjQ64=;
        b=JLxLT7TvqF3telNag5NCl1k1GEeU8s68HMUatoo/1iIyneIhmCdxmtfntTkyplbW5c
         /z7BKwGkJORAXy7m+ySYe8f8uP0ZHgGAe53Vs6vcVRAIhQ52phhjK8VBTbpCMXogizD5
         WJyQ6XkQxcQBpk70zcq8oCamHLmi2YkZbTbgIRnZ8dtBj7EoZTE/eDogG/38Li1jJnla
         GA6DvBeQlYw+oQLPUvZRquHCcFrYJJYuZ8/b8tU7un/ireY5dE2BsDVkzTRVLEv6+nfU
         7BwUzbtHcqS2wF63iRDMaI/oChxTuTs48zkDzZJDL4ZoW8jrZJVjYhMhtntP9ql800sE
         s4mA==
Content-Disposition: inline
In-Reply-To: <20130107164707.GI3926-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 07, 2013 at 08:47:07AM -0800, Tejun Heo wrote:
> On Sun, Jan 06, 2013 at 05:27:46PM +0800, Li Zefan wrote:
> > Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> I'll route this together with "decouple cpuset locking" patchset in a
> separate branch in cgroup tree.  If anyone objects, please let me
> know.

I put the cgroup_rightmost_descendant() patch in cgroup/for-3.9 and
the rest in cgroup/for-3.9-cpuset.

Thanks.

-- 
tejun
