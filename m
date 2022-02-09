From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/12] cgroup: rstat: Make cgroup_rstat_cpu_lock name
 readable
Date: Wed, 9 Feb 2022 13:29:16 -1000
Message-ID: <YgROTNCwS50FSCx9@slm.duckdns.org>
References: <20220208194324.85333-1-namhyung@kernel.org>
 <20220208194324.85333-3-namhyung@kernel.org>
 <4b58c74d-6ad6-3658-30fb-1957a7b212dc@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vyxdt1qWwEixzQmfvtesRM+4XY4WJ+b7HT9Q8ZLfLAs=;
        b=pZi+PzBgTTefzJeng26sb/vNM7MsBFngkh6o84QEptniKvStYo9EIzPewsyVg2dOyf
         fG/NKLlkk0Sprdqloz7mNTwVMJR93Fg2z8pNm6e2jqtpDYjBmhDJdNKfHQXmzFXDiXCv
         JA7Vtwt57onmIqPQYdaOknNh2Z6/sqm4jkjEAfQn4ynDMSIBekuHsbiByNBuXRcIF0EH
         FCAQ2Z9HJ9GOs9ZQenWKWEoyA6iNyKABSXd+9DLjeajfXBmFlYZvBxZBkBjK/Z855UvD
         kstoetOSqUgPaLcpDkWbIxoovoqKHk716dho+phSXFGtyI1CgQJ3M1+R2nypg592amPQ
         CiPw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4b58c74d-6ad6-3658-30fb-1957a7b212dc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Byungchul Park <byungchul.park-Hm3cg6mZ9cc@public.gmane.org>, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Radoslaw Burny <rburny-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 09, 2022 at 03:20:42PM -0500, Waiman Long wrote:
> That is a standalone fix. Maybe Tejun can take it directly into the cgroup
> tree.
> 
> Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Yeah, I sure can but the change is rather immaterial from cgroup POV and it
might be easier to route it with the rest of the patchset to avoid cross
tree pulls. I'd be happy either way. Please let me know once things settle
and the patchset is ready for merging.

Thanks.

-- 
tejun
