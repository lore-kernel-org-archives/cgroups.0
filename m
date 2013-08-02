From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead of
 cgroup in subsystem methods
Date: Fri, 2 Aug 2013 15:38:45 -0400
Message-ID: <20130802193845.GD29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-9-git-send-email-tj@kernel.org>
 <20130802131901.GB25432@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VAJIbhXwaMG9j6hHunD8oSm16mptuQ8HKVgZ0z70fr0=;
        b=s8JrKcf1fcAQA3Ar7X8KWykIX1lk33JQmwfvnkhQsCpm7ePEMzkaCy1RZYkWaiAlAL
         m7RB8v55et+DO3q1Dpz0Lu+h1IU7wkr7xdA49dVBBgzUR6NSk7RRnC9bsFC64+a0a0Sf
         opEsWzXhlAffYlz7Ca+jsWakp+Wfkc+vqkoXuSUZvBdRnVFlLPYQhkIZOm4N/cfPSHP6
         ao0nfXt1dvvKG/NEBmBljnq9u9jOJwk7OLHNiIMeUqCDJBqcdEGZhKLUA0XUkIG1EfQr
         DQAD7cYx6THsKq2t/6VqshfceHirSiKbqelmfGCPvHce8SFp1hkF/xsKIv03tKhzBlB0
         CtNQ==
Content-Disposition: inline
In-Reply-To: <20130802131901.GB25432-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

On Fri, Aug 02, 2013 at 03:19:01PM +0200, Michal Hocko wrote:
> mem_cgroup_from_cont can go away now as well. Do you plan to remove it
> in the series or later on?

IIRC, vmpressure still uses the accessor.  It'll get removed later
when all the usages are gone.

Thanks.

-- 
tejun
