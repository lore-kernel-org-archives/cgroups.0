From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Tue, 13 Mar 2012 09:02:18 -0700
Message-ID: <20120313160218.GC7349@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <20120313134922.GB29169@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+5X+8tnZTmwQZMQzUuxcwVG24r6hMuHYTqYNPoeeXm0=;
        b=vloplcahMUEYwHZKsFouITfShrFbzEvAAUU+e1Vbk6XrVtXgLBN9w3n+FKCvDu+TkM
         OFyRWLIppzsf18Mt2XTfTVXkd1LMRVMwyueKWYrDoTDctlmx0wCMlZIrzUBYdH3l7f/a
         OkqDH9E/yeEbN3GhuRuxQggRH+cYl+QbRFYpmfvCM5KPZElIInFscFVhqqwMkH2cCbZo
         ed4ufb1OpRvIp2h/GShjFnxKv0WH7Ae9ATqzI7QEyS0DG+a3iRF9kUVHqgU176S15riP
         ORR+JzJlW4tsR4Jbqh0uxGNC7LEyI+Ty9q+MpkhqcUNJayIR8Hmx4FJItLvi2X8ORQlt
         FZ6w==
Content-Disposition: inline
In-Reply-To: <20120313134922.GB29169-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello,

On Tue, Mar 13, 2012 at 09:49:22AM -0400, Vivek Goyal wrote:
> So everything will be under single hierarchy? How will we control that
> what controllers are active on what cgroups? Or all controllers are going
> to be active on all cgroups on that hierarchy. 
> 
> That would be bad for IO cgroups where a better way to use it to isolate
> the trouble making workload and run rest in root or a common cgroup.

Depending on active configs, I guess, or maybe we'll have active
controllers mask which can also be used for single-level restriction
for controllers which don't support full hierarchy.

Thanks.

-- 
tejun
