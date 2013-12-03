From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 3 Dec 2013 08:45:06 -0500
Message-ID: <20131203134506.GG8277@htj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=osDz+F2t7w9YlQLCn/uYmdw/S8fatVbQahUhUJ+n9L0=;
        b=ITCel2oJyii1Awva4527v70Bt1nqygPtaEpIGqxhTZs1bPjSrDk+IMyxmpNp0kJkTl
         ixZCODPXfZ65ptCi0aC5svKGNDDC7DmpjXoS2opwIHb0TGB15LcZJwdHZ2yZXydhxsY2
         xZD80f72eI1OG/3yJiGM0AA80RIauZ5Won6eRxw1F93fo/H7bAZ9cuula1J0ks7PChyz
         8N+Zz62ntv+6voLlTrqNGVUvyjlDcFAwasNf/KrSlcAhKdA4onZddMPqIikkmtWJLvss
         pO3LiwP9Qioz6YJIPcTkGI4R+LQhXXTyhf1d2akqCUhSUdC+PShENrIpgJ0QoQpkJRQk
         O0cQ==
Content-Disposition: inline
In-Reply-To: <20131125224335.GA15481-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

Hello, guys.

Sorry about the delay.

On Mon, Nov 25, 2013 at 10:43:35PM +0000, Serge E. Hallyn wrote:
> Additionally, Tejun has specified that we do not want users to be
> too closely tied to the cgroupfs implementation.  Therefore
> commands will be just a hair more general than specifying cgroupfs
> filenames and values.  I may go so far as to avoid specifying
> specific controllers, as AFAIK there should be no redundancy in
> features.  On the other hand, I don't want to get too general.
> So I'm basing the API loosely on the lmctfy command line API.

One of the reasons for not exposing knobs as-is is that the knobs we
currently have aren't consistent.  The weight values have different
ranges, some combinations of values don't make much sense, and so on.
The user can cope with it but it'd probably be better to expose
something which doesn't lead to mistakes too easily.

> The above addresses
>     * creating cgroups
>     * chowning cgroups
>     * setting cgroup limits
>     * moving tasks into cgroups
>   . but does not address a 'cgexec <group> -- command' type of behavior.
>     * To handle that (specifically for upstart), recommend that r do:
>       if (!pid) {
>         request_reclassify(cgroup, getpid());
>         do_execve();
>       }
>   . alternatively, the daemon could, if kernel is new enough, setns to
>     the requestor's namespaces to execute a command in a new cgroup.
>     The new command would be daemonized to that pid namespaces' pid 1.

So, IIUC, cgroup hierarchy management - creation and removal of
cgroups and assignments of tasks will go through while configuring
control knobs will be delegated to the cgroup owner, right?

Hmmm... the plan is to allow delegating task assignments in the
sub-hierarchy but require CAP_X for writes to knobs (not reads).  This
stems from the fact that, especially with unified hierarchy, those
operations will be cgroup-core proper operations which are gonna be
relatively safer and that task organizations in the subhierarchy and
monitoring knobs are likely to be higher frequency operation than
enabling and configuring controllers.

As I communicated multiple times before, delegating write access to
control knobs to untrusted domain has always been a security risk and
is likely to continue to remain so.  Also, organizationally, a
cgroup's control knobs belong to the parent not the cgroup itself.
That probably is why you were thinking about putting an extra cgroup
inbetween for isolation, but the root problem there is that those
knobs belong to the parent, not the directory itself.

Security is in most part logistics - it's about getting all the
details right, and we don't either design or implement each knob with
security in mind and DoSing them has always been pretty easy, so I
don't think delegating write accesses to knobs is a good idea.

If you, for whatever reason, can trust the delegatee, which I believe
is the case for google, it's fine.  If you're trying to delegate to a
container which you don't have any control over, it isn't a good idea.

Another thing to consider is due to both the fundamental characterics
of hierarchy and implementation issues, things will become expensive
if nesting gets beyond several layers (if controllers are enabled,
that is) and the controllers in general will be implemented and
optimized with limited level of nesting in mind.  IOW, building, say,
8 level deep hierarchy in the host and then doing the same thing
inside the container with controllers enabled won't make a very happy
system.  It probably is something to keep in mind when laying out how
the whole thing eventually would look like.

> Long-term we will want the cgroup manager to become more intelligent -
> to place its own limits on clients, to address cpu and device hotplug,
> etc.  Since we will not be doing that in the first prototype, the daemon
> will not keep any state about the clients.

Isn't the above conflicting with chowning control knobs?

Thanks.

-- 
tejun
