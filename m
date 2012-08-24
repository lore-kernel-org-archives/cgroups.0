From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Date: Thu, 23 Aug 2012 17:02:34 -0700
Message-ID: <87ipc9kvhh.fsf@xmission.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
	<20120816174454.087507415@napanee.usersys.redhat.com>
	<20120816200006.GG24861@google.com> <50340110.50607@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50340110.50607-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Lennart Poettering's message of
	"Tue, 21 Aug 2012 23:43:44 +0200")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Heya,
>
> (sorry for the late reply)
>
> On 16.08.2012 22:00, Tejun Heo wrote:
>> On Thu, Aug 16, 2012 at 01:44:56PM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
>
>>>> Attaching meta information to services, in an easily discoverable
>>>> way. For example, in systemd we create one cgroup for each service, and
>>>> could then store data like the main pid of the specific service as an
>>>> xattr on the cgroup itself. That way we'd have almost all service state
>>>> in the cgroupfs, which would make it possible to terminate systemd and
>>>> later restart it without losing any state information. But there's more:
>>>> for example, some very peculiar services cannot be terminated on
>>>> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
>>>> services in question could just mark that on their cgroup, by setting an
>>>> xattr. On the more desktopy side of things there are other
>>>> possibilities: for example there are plans defining what an application
>>>> is along the lines of a cgroup (i.e. an app being a collection of
>>>> processes). With xattrs one could then attach an icon or human readable
>>>> program name on the cgroup.
>>>>
>>>> The key idea is that this would allow attaching runtime meta information
>>>> to cgroups and everything they model (services, apps, vms), that doesn't
>>>> need any complex userspace infrastructure, has good access control
>>>> (i.e. because the file system enforces that anyway, and there's the
>>>> "trusted." xattr namespace), notifications (inotify), and can easily be
>>>> shared among applications.
>
>>
>> I'm not against this but unsure whether using kmem is enough for the
>> suggested use case.  Lennart, would this suit systemd?  How much
>> metadata are we talking about?
>
> Just small things, like values, PIDs, i.e. a few 100 bytes or so per cgroup
> should be more than sufficient for our needs.

I have a really silly question.  Why is storing these things in xattrs
in a cgroup better than simply implementing a file in a cgroup?

It is most definitely going to be a real pain to discover as unix tools
do not support xattrs well.

Furthermore I am having nasty visiions that storing pids is going to
start breaking cgroups the way storing pids already breaks futexes.
Which pid namespace is that pid relative to?

Eric
