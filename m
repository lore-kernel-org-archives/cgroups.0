From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Thu, 21 Oct 2021 07:06:05 -1000
Message-ID: <YXGd/T0YHG/xEAkw@slm.duckdns.org>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
 <a0f9ed06-1e5d-d3d0-21a5-710c8e27749c@linux.ibm.com>
 <YWirxCjschoRJQ14@slm.duckdns.org>
 <b5f8505c-38d5-af6f-0de7-4f9df7ae9b9b@linux.ibm.com>
 <YW2g73Lwmrhjg/sv@slm.duckdns.org>
 <77854748-081f-46c7-df51-357ca78b83b3@linux.ibm.com>
 <YXBFVCc61nCG5rto@slm.duckdns.org>
 <bd1811cc-0e04-9e44-0b46-02689ff9a238@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrhIGZEqu0h/B8SeVSRWWn+zXKY1Hb4XraNoMEue39w=;
        b=OA705iIhr1YeBmH3LY1wuCrgfL3CUIvPxUFSRUYOFLixDWJ9TtX9x0pjMdukts/TdN
         aqXY23DJC+n0Mhx1JwFCNmnb0QvKL+AkBtOPdksPbpodAsZGKpKUp/R3Pr6QRt0IuSzr
         KS/WNb+Mvv5CVTVbuIdcK/5ZHYS6cN/etcx16Rc1NzHhH0IZGcAECTbnQfbgk3UY9FEG
         HnsSFWAfHrLCWehkpvqtY8RYoCWngNQoyPpeHfkAEHxTnNraxY2i52QEePbjkdpoglgM
         +cveexLYdYNMeRr61ZopCZ1boXOX6XShZbQEOJSZRz/3xBePCVgxaMhNi+E8oUdgznBY
         JOvQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bd1811cc-0e04-9e44-0b46-02689ff9a238-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pratik Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

On Thu, Oct 21, 2021 at 01:14:10PM +0530, Pratik Sampat wrote:
> I'm speculating, and please correct correct me if I'm wrong; suggesting
> an optimal number of threads to spawn to saturate the available
> resources can get convoluted right?
> 
> In the nginx example illustrated in the cover patch, it worked best
> when the thread count was N+1 (N worker threads 1 master thread),
> however different applications can work better with a different
> configuration of threads spawned based on its usecase and
> multi-threading requirements.

Yeah, I mean, the number would have to be based an ideal conditions - ie.
the cgroup needs N always-runnable threads to saturate all the available
CPUs and then applications can do what they need to do based on that
information. Note that this is equivalent to making these decisions based on
number of CPUs.

> Eventually looking at the load we maybe able to suggest more/less
> threads to spawn, but initially we may have to have to suggest threads
> to spawn as direct function of N CPUs available or N CPUs worth of
> runtime available?

That kind of dynamic tuning is best done with PSI which can reliably
indicate saturation and the degree of contention.

> > The other
> > metric would be the maximum available fractions of CPUs available to the
> > cgroup subtree if the cgroup stays saturating. This number is trickier as it
> > has to consider how much others are using but would be determined by the
> > smaller of what would be available through cpu.weight and cpu.max.
> 
> I agree, this would be a very useful metric to have. Having the
> knowledge for how much further we can scale when we're saturating our
> limits keeping in mind of the other running applications can possibly
> be really useful not just for the applications itself but also for the
> container orchestrators as well.

Similarly, availability metrics would be useful in ballpark sizing so that
applications don't have to dynamically tune across the entire range, the
actual adustments to stay saturated is likely best done through PSI, which
is the direct metric indicating resource saturation.

Thanks.

-- 
tejun
