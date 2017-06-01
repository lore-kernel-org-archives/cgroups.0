From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Thu, 1 Jun 2017 17:10:45 +0200
Message-ID: <20170601151045.xhsv7jauejjis3mi@hirez.programming.kicks-ass.net>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
 <20170524203616.GO24798@htj.duckdns.org>
 <9b147a7e-fec3-3b78-7587-3890efcd42f2@redhat.com>
 <20170524212745.GP24798@htj.duckdns.org>
 <20170601145042.GA3494@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eqKsBvRj5fLRZ3WbQ4Q3QmN6zlW9zDNsMKGmA31Fa8Q=; b=QrGX83OH72azrDrLcaDVXUhS9
        nn98k2QQr7Vr7i0I9SvjccQId8KUio+ZDUPtPBOwNetMjNUxniV8xD1xaQ9pI4Igw4Sl3Xl9XhhvL
        m7jusBwuLjSUq8VXFX4YUkCJYYd1Rk8UdHOD18rUS5pPB2aJorYKv57lR2mXIdfTTUN15ZrPyR2FQ
        Tv+Kxr1V4TfCc8udyOocj0mUAIJbPUFjiJSsuf/jOKDsYQC7hVGDPUeFvd2UMyrXz5Prb3dwbYoKR
        TZH1jWzdBo+G3KtpCXIiEQlg0hXyfni+aV0XH1Tj3FE6/H8bhmaX/4Sgz1tkOyksZRgECW+Mefakk
      
Content-Disposition: inline
In-Reply-To: <20170601145042.GA3494-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

On Thu, Jun 01, 2017 at 10:50:42AM -0400, Tejun Heo wrote:
> Hello, Waiman.
> 
> A short update.  I tried making root special while keeping the
> existing threaded semantics but I didn't really like it because we
> have to couple controller enables/disables with threaded
> enables/disables.  I'm now trying a simpler, albeit a bit more
> tedious, approach which should leave things mostly symmetrical.  I'm
> hoping to be able to post mostly working patches this week.

I've not had time to look at any of this. But the question I'm most
curious about is how cgroup-v2 preserves the container invariant.

That is, each container (namespace) should look like a 'real' machine.
So just like userns allows to have a uid-0 (aka root) for each container
and pidns allows a pid-1 for each container, cgroupns should provide a
root group for each container.

And cgroup-v2 has this 'exception' (aka wart) for the root group which
needs to be replicated for each namespace.

