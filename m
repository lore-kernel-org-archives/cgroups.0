From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] percpu: improve percpu_alloc_percpu event trace
Date: Sun, 15 May 2022 18:06:40 -0400
Message-ID: <20220515180640.0ae2ead5@gandalf.local.home>
References: <2b388d09-940e-990f-1f8a-2fdaa9210fa0@openvz.org>
        <a07be858-c8a3-7851-9086-e3262cbcf707@openvz.org>
        <YnsgbXKiNNSF+1ZO@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-trace-users-owner@vger.kernel.org>
In-Reply-To: <YnsgbXKiNNSF+1ZO@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vasily Averin <vvs@openvz.org>, Shakeel Butt <shakeelb@google.com>, Ingo Molnar <mingo@redhat.com>, kernel@openvz.org, linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, linux-mm@kvack.org, "linux-trace-users@vger.kernel.org" <linux-trace-users@vger.kernel.org>

On Tue, 10 May 2022 19:33:17 -0700
Roman Gushchin <roman.gushchin@linux.dev> wrote:

>  --- a/include/trace/events/percpu.h
> > +++ b/include/trace/events/percpu.h
> > @@ -6,15 +6,20 @@
> >  #define _TRACE_PERCPU_H
> >  
> >  #include <linux/tracepoint.h>
> > +#include <trace/events/mmflags.h>
> >  
> >  TRACE_EVENT(percpu_alloc_percpu,
> >  
> > -	TP_PROTO(bool reserved, bool is_atomic, size_t size,
> > -		 size_t align, void *base_addr, int off, void __percpu *ptr),
> > +	TP_PROTO(unsigned long call_site,
> > +		 bool reserved, bool is_atomic, size_t size,
> > +		 size_t align, void *base_addr, int off,
> > +		 void __percpu *ptr, size_t bytes_alloc, gfp_t gfp_flags),  
> 
> Don't we want to preserve the order and add the call_site at the end?
> Trace events are not ABI, but if we don't have a strong reason to break it,
> I'd preserve the old order.

Ideally everyone should be using libtraceevent which will parse the format
file for the needed entries.

Nothing (important) should be parsing the raw ascii from the trace files.
It's slow and unreliable. The raw format (trace_pipe_raw) files, along with
libtraceevent will handle fining the fields you are looking for, even if
the fields move around (internally or externally).

Then there's trace-cruncher (a python script that uses libtracefs and
libtraceevent) that will work too.

  https://github.com/vmware/trace-cruncher

-- Steve
