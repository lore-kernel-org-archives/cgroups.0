From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 13:49:53 -0500
Message-ID: <54F0BC51.4050506@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com> <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com> <20150227170640.GK3964@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=nge18UmUoz3Oi4ix5vrHDhbeFueLlXnEnlqauOqYkhc=;
        b=KCt9aF6AiwHbde/vtAUbn9qoYCgQsDFUocRW7KZv2m5cpoZQoog4TKSf5QfNONia+Y
         ofPCAl/X40KBKeB8WZ/TmXknDbJ3e3KRRHoAzk8ZdF/TCTqbKiuf9iYqmv5W2OD2/wQH
         9FD0aFhKpFyuY3G6/duKB/L652uf9dUUVL7dll4/qKGdyaACh3FqRnDz3QwQrgbPoznk
         qTipfaNkcJAX7sJUCb1L4gDN51ltEqaLMvjM7g2m+J9xvuoWSYKoUpP18QgsAt8glzJF
         xbxDmOokkXglBILgpIEaM5IZ8JF4cCJgSTtpn7qaJtXXRZzEa21REiZgzYCZ6FFDPqoN
         e6Lw==
In-Reply-To: <20150227170640.GK3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-02-27 12:06, Tejun Heo wrote:
> Hello,
>
> On Fri, Feb 27, 2015 at 11:42:10AM -0500, Austin S Hemmelgarn wrote:
>> Kernel memory consumption isn't the only valid reason to want to limit the
>> number of processes in a cgroup.  Limiting the number of processes is very
>> useful to ensure that a program is working correctly (for example, the NTP
>> daemon should (usually) have an _exact_ number of children if it is
>> functioning correctly, and rpcbind shouldn't (AFAIK) ever have _any_
>> children), to prevent PID number exhaustion, to head off DoS attacks against
>> forking network servers before they get to the point of causing kmem
>> exhaustion, and to limit the number of processes in a cgroup that uses lots
>> of kernel memory very infrequently.
>
> All the use cases you're listing are extremely niche and can be
> trivially achieved without introducing another cgroup controller.  Not
> only that, they're actually pretty silly.  Let's say NTP daemon is
> misbehaving (or its code changed w/o you knowing or there are corner
> cases which trigger extremely infrequently).  What do you exactly
> achieve by rejecting its fork call?  It's just adding another
> variation to the misbehavior.  It was misbehaving before and would now
> be continuing to misbehave after a failed fork.
>
I wouldn't think that preventing PID exhaustion would be all that much 
of a niche case, it's fully possible for it to happen without using 
excessive amounts of kernel memory (think about BIG server systems with 
terabytes of memory running (arguably poorly written) forking servers 
that handle tens of thousands of client requests per second, each 
lasting multiple tens of seconds), and not necessarily as trivial as you 
might think to handle sanely (especially if you want callbacks when the 
limits get hit).
As far as being trivial to achieve, I'm assuming you are referring to 
rlimit and PAM's limits module, both of which have their own issues. 
Using pam_limits.so to limit processes isn't trivial because it requires 
calling through PAM to begin with, which almost no software that isn't 
login related does, and rlimits are tricky to set up properly with the 
granularity that having a cgroup would provide.
> In general, I'm pretty strongly against adding controllers for things
> which aren't fundamental resources in the system.  What's next?  Open
> files?  Pipe buffer?  Number of flocks?  Number of session leaders or
> program groups?
>
PID's are a fundamental resource, you run out and it's an only 
marginally better situation than OOM, namely, if you don't already have 
a shell open which has kill builtin (because you can't fork), or have 
some other reliable way to terminate processes without forking, you are 
stuck either waiting for the problem to resolve itself, or have to reset 
the system.
> If you want to prevent a certain class of jobs from exhausting a given
> resource, protecting that resource is the obvious thing to do.
>
Which is why I'm advocating something that provides a more robust method 
of preventing the system from exhausting PID numbers.
> Thanks.
>
