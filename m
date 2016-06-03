From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Fri, 3 Jun 2016 16:26:21 +0530
Message-ID: <CAG53R5W3v4Jz+LFLFBfCV6kbX-Vy1xCTD1KLJPh3SGkaxitrdQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=/2obJtbDc5ntoYklDHOVz8UrMUMYabwxXEUZ6IRcdN8=;
        b=pDggxJ3/Pc+wRbqHI7qxZoV7wyoSx6ltkaoJ69dtpxpubVaMix2JDwGYdrTzvxEzqn
         l44A3s/+Ud+8Ju+tJ4xfAb9W9MvPKTbYmPBvMSqshmlpdqm4J/gUgfQL3guwOzO+LXhL
         QfGxjCRKj6hcvIZq35b0KiPHKdXXFCWmaz1rxROblJESYhJYKYoA1r2jy+H9+s/bFfZw
         XmWIMCFVCxN/soJJwWtAUFtYnVtFcF083+wYJ8LHiNA9ARzmkdCIb4cRrDzObd63LS/l
         I7iLVGkfBM3gcAlNYOTRzQ0v4GvjnxkvXZ1MKK9lB43N9UPdmbOmWqeM1OSeqcmBoq4A
         j19w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Christoph,

Reopening thread for discussion so that I can proceed to generate next patch.

Recap:
rdma cgroup controller in the patch defines the framework so that RDMA
subsystem can define the resources.
This is similar to at least two functionality provided by core kernel.

(a) Block elevator defining framework and provides way to loadable
kernel modules to define actual IO scheduler (out of the 3 or 4) that
can be plugged-in since last many years.
(b) VFS core defining framework for external loadable modules to load
file system.

None of these core kernel functionality actually filter based on enum
or names - which IO scheduler(s), file system(s) are
allowed/disallowed.
rdma cgroup controller and rdma subsystem follows similar design approach.

Therefore can I go ahead with current approach?

Tejun also mentioned that he likes to see rdma resources to be defined
by rdma cgroup rather than rdma subsystem in below thread primarily to
reduce the complexity.
https://lkml.org/lkml/2016/4/4/507

However submitted patch is fairly small for defining resource in rdma
subsystem (instead of kernel).
This also allows to provide fixes and features done in rdma subsystem
in field at much faster pace and avoids complexity around back-porting
on various OS and their kernel flavors.
Please let me know your views.

Regards,
Parav Pandit



On Tue, Apr 19, 2016 at 2:26 PM, Parav Pandit <pandit.parav@gmail.com> wrote:
> Hi Christoph,
>
> I was on travel. Sorry for the late inline response and question.
>
> Parav
>
>
>
> On Tue, Apr 5, 2016 at 10:57 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Tue, Apr 05, 2016 at 05:55:26AM -0700, Parav Pandit wrote:
>>> Just because we add one more rdma resource, we need to ask someone to
>>> upgrade kernel?
>>
>> Yes.  Just like when you need any other core kernel resource.
>
> By architecture Linux kernel allows
> (a) plugin of any new block level IO scheduler as kernel module.
> This is much more fundamental resource or functionality than rdma resource.
> (b) plugin of any new file system as kernel module.
>
> Changing both in field and out of box can do be more harmful than
> defining new rdma resource.
>
> RDMA Resource definition by IB core module is very similar to above
> two functionality, where elevator and VFS provides basic support
> framework and so rdma cgroup controller here.
>
> So can you please help me understand - which resource did you compare
> against in your above comment for "core kernel resource"?
> I compared it with similar functionality, flexibility given by (a)
> block IO Scheduler and (b) VFS subsystem to implement them as kernel
> module.
