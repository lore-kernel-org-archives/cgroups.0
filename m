From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes 2/3] cgroup: fix handling of
 multi-destination migration from subtree_control enabling
Date: Thu, 3 Dec 2015 10:38:26 -0500
Message-ID: <20151203153826.GI27463@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de>
 <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de>
 <20151124145945.GF17033@mtj.duckdns.org>
 <20151130224205.GA9039@mtj.duckdns.org>
 <20151130224431.GB9039@mtj.duckdns.org>
 <20151203151632.GE27463@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=YzdQvRZY6CwnTFpBlx/WrfoE/TyugosdI3Froa+k1HQ=;
        b=bDB2R0k6pEc6lK216baXN1gzsuljBRyASJWZPZJSU9tpUY5I/Cl2+EyCUnwmTESIq6
         s+l30ZPhKxYQ4qMroUsarl9XbIYwVcmH+Bo2sMOS78Ls6eRYP56oCx8NyyJuPl4SltEf
         yTT4wndGmsRGaXPqSGUiQKEuwAXlDSQBCynTK7qm6v0VlzEudHnFNl3v1XuFBers5Dce
         h5MLQ6oCCBHMSmFORsgkmy2mW1LN/uHDi2szWW/cPPFQmDz8swgKX3K2ghx0ibA+JJTZ
         WjdWUTlsdy7OTMMhUPLeODlYHi68giM+W3RqgF14APmYkXtGNnDkS9fk2BUp9SBUUOqP
         jVSw==
Content-Disposition: inline
In-Reply-To: <20151203151632.GE27463-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Thu, Dec 03, 2015 at 10:16:32AM -0500, Tejun Heo wrote:
> Applying 1-2 to libata/for-4.4-fixes.

That should have been cgroup/for-4.4-fixes.

Thanks.

-- 
tejun
