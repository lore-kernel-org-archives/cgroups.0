From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Mon, 12 Mar 2012 16:04:16 -0700
Message-ID: <20120312230416.GM23255@google.com>
References: <20120221211938.GE12236@google.com>
	<20120312221050.GG23255@google.com>
	<1331590938.18960.57.camel@twins>
	<20120312222817.GI23255@google.com>
	<1331591568.18960.61.camel@twins>
	<20120312223944.GJ23255@google.com>
	<1331592241.18960.64.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=n/jAEkjYiuHLwu9OsgY5+xdbh+SjEN2lluMmAdtyKk4=;
	b=y/9esYW7GA/9znrQdz/Vn/RWdflq3sG6f3szMfyzIRTrM0eqAnFNw/i1tJyYEYKW/C
	9D4JeT9Fa+jvLzsS8KEPhjV68bG3jRXjZ9FEw5vLwaNEIrWhBjGwrCN33IWPwj1vKdaB
	yNkt7h2qc82OSuG8FWWe18G7dCuE6JKw3BWwfdbsbKW1m44HTGXWmB8SaqBo1lyf+gXd
	/6zRWPIGi8KSUGsMw09UC6vEB4sSdWRwbLNbZ6n5jl5aFa4bIRvLv2VMdesXxjBAywVS
	Ktk0Pnq7AkTAW6pyAaP+pDz/FEx7d0hwCDk0LBCHxfx5aWP1LtdQ4DirlBRryDsm3svQ
	GRng==
Content-Disposition: inline
In-Reply-To: <1331592241.18960.64.camel@twins>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Mar 12, 2012 at 11:44:01PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 15:39 -0700, Tejun Heo wrote:
> > If we can get to the point where nesting is fully
> > supported by every controller first, that would be awesome too. 
> 
> As long as that is the goal.. otherwise, I'd be overjoyed if I can rip
> nesting support out of the cpu-controller.. that stuff is such a pain.
> Then again, I don't think the container people like this proposal --
> they were the ones pushing for full hierarchy back when.

Yeah, the great pain of full hierarchy support is one of the reasons
why I keep thinking about supporting mapping to flat hierarchy.  Full
hierarchy could be too painful and not useful enough for some
controllers.  Then again, cpu and memcg already have it and according
to Vivek blkcg also had a proposed implementation, so maybe it's okay.
Let's see.

Thanks.

-- 
tejun
