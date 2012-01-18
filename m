From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Wed, 18 Jan 2012 16:27:18 +0800
Message-ID: <4F168266.3060205@cn.fujitsu.com>
References: <4F13DA90.2000603@cn.fujitsu.com> <4F13DAA9.4070703@cn.fujitsu.com> <20120117175322.GC6762@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120117175322.GC6762-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 16, 2012 at 04:07:05PM +0800, Li Zefan wrote:
>> This is one of the items in the plumber's wish list.
>>
>> For use cases:
>>
>>>> What would the use case be for this?
>>>
>>> Attaching meta information to services, in an easily discoverable
>>> way. For example, in systemd we create one cgroup for each service, and
>>> could then store data like the main pid of the specific service as an
>>> xattr on the cgroup itself. That way we'd have almost all service state
>>> in the cgroupfs, which would make it possible to terminate systemd and
>>> later restart it without losing any state information. But there's more:
>>> for example, some very peculiar services cannot be terminated on
>>> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
>>> services in question could just mark that on their cgroup, by setting an
>>> xattr. On the more desktopy side of things there are other
>>> possibilities: for example there are plans defining what an application
>>> is along the lines of a cgroup (i.e. an app being a collection of
>>> processes). With xattrs one could then attach an icon or human readable
>>> program name on the cgroup.
>>>
>>> The key idea is that this would allow attaching runtime meta information
>>> to cgroups and everything they model (services, apps, vms), that doesn't
>>> need any complex userspace infrastructure, has good access control
>>> (i.e. because the file system enforces that anyway, and there's the
>>> "trusted." xattr namespace), notifications (inotify), and can easily be
>>> shared among applications.
>>>
>>> Lennart
>>
>> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> 
> Ummm... I don't feel too good about this.  Why can't those extra
> information be kept somewhere else?  Overloading cgroupfs as storage
> for essentially opaque userland information doesn't seem like a good
> idea to me.
> 

Long ago Paul M toyed with a patch that adds a control file for userspace
to read/write per-cgroup user information, but there were no use cases.
This patchset has a similar purpose, but this interface is more flexable
and easier to use, and we do have systemd as a use case this time.

I'll let Lennart answer if we can easily live without this.

Furthermore, I noticed tmpfs also implemented xattr support, and we
should be able to share most of the code, which makes the cost for
having this feature smaller.
