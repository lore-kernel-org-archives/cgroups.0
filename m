From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] kernfs, cgroup: reimplement "cgroup.procs" reading
 for v2
Date: Tue, 27 Dec 2016 14:53:54 -0500
Message-ID: <20161227195354.GC31771@htj.duckdns.org>
References: <20161220161222.15234-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ezLZc2CD05AA59EIRuRRDHP4DZiaKHM25lgX7BWxFxs=;
        b=MgQ6kQ02KMvTKBIXnjsCWw2vWgrLztNEESItRqtGV7Q/y+x42Qp3V5194b7Qgaogft
         KmB4wpNZZKVhOXFUy41vt/brw5/cdok9QrfsigHkPjl0mpVDVUH7CoUPU1kTPhYv96id
         qy4y8XNeP4JtzCJrJV31nciRZc+bSCsn0E28BPrAk4Qmv+szUubkrs4juIlTvr3hLgTv
         ypgipr9JHEOrKw/b2nHuqpR6M2e4JA5Ex+aCJ/znEl+HhA2X/x+zuE7er8O4AzGOAtMD
         su55a/aLmFYJB8Q6GHJQlW57mgos1wNrnHr6uPU5FjA18e5NZ1dcz1rEObDB+a8MCmS1
         FzdA==
Content-Disposition: inline
In-Reply-To: <20161220161222.15234-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Dec 20, 2016 at 11:12:17AM -0500, Tejun Heo wrote:
> On cgroup v1, the pid listings in "cgroup.procs" and "tasks" are
> sorted which adds a lot of complications and overhead.  v2 doesn't
> have such requirement and has been intentionally using a modified
> sorting order so that the output doesn't look sorted to users.
> 
> This patchset re-implements "cgroup.procs" reading for v2 which simply
> keeps a css_task_iter open while the file is being read.  Keeping the
> iterator open makes it unnecessary to skip to the right position on
> each read segment and associated errors - e.g. incorrectly skipping
> over pids because earlier pids disappeared between the reads.
> 
> Using persistent iterator across multiple read calls requires
> ->release() callback to clean it up.  kernfs operations
> ->open/release() are added and piped through cftype.

Applied to cgroup/for-4.11.

-- 
tejun
