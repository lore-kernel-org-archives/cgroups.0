From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 19 Apr 2016 14:26:08 +0530
Message-ID: <CAG53R5Xt1J9+SBvAFRQOcwvkFzeLMkTZ-7vyBG2BVPYdU8p4Nw@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
	<CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
	<20160405012504.GG24661@htj.duckdns.org>
	<20160405090627.GA26425@infradead.org>
	<CAG53R5WBBUj6=B81Q-zEwL_xy3_yXUofJ6p921baqnqeVocDPQ@mail.gmail.com>
	<20160405124252.GA4348@infradead.org>
	<CAG53R5UOogG1itd8AzMOWnpnyGqKSRLY4CNrX5HWGfdF3q-F3w@mail.gmail.com>
	<20160405172720.GA31055@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=msyJ9U1SsjmZCRr8093QaS0lbfb2lIaI+P60rTJ7ZYg=;
        b=w+gwy/3H/BRM/MjOI15h299PgkOuvC+djczSaf11PwZtYPX7iNERRXAm6v9AI0zmk1
         MaUsjScpqtuATZ96VxHRwz4d437GFwsgwP/ih9sJ1/rqqsA+KBmueVYwmq7JT9iXGjIM
         33/s4UJDjFKf0XowEkrNOtQpDDfgjzGGK0qFtBDsf7RK1Bweytnli8cvqzszhzhYHYVR
         CP49JT13IVxSGJoAWiBtZBbHruTgWnxuvClFPJ9Ml00lWnQfpbqx2ppZ+Z63em8yr4Yz
         wifqEFLs84OQFkaqhqpaCRSTWalj8/SKscmMP0ZxbIbQkekct303l/kG77ZH74WIJrKd
         CZBw==
In-Reply-To: <20160405172720.GA31055@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Christoph,

I was on travel. Sorry for the late inline response and question.

Parav



On Tue, Apr 5, 2016 at 10:57 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 05, 2016 at 05:55:26AM -0700, Parav Pandit wrote:
>> Just because we add one more rdma resource, we need to ask someone to
>> upgrade kernel?
>
> Yes.  Just like when you need any other core kernel resource.

By architecture Linux kernel allows
(a) plugin of any new block level IO scheduler as kernel module.
This is much more fundamental resource or functionality than rdma resource.
(b) plugin of any new file system as kernel module.

Changing both in field and out of box can do be more harmful than
defining new rdma resource.

RDMA Resource definition by IB core module is very similar to above
two functionality, where elevator and VFS provides basic support
framework and so rdma cgroup controller here.

So can you please help me understand - which resource did you compare
against in your above comment for "core kernel resource"?
I compared it with similar functionality, flexibility given by (a)
block IO Scheduler and (b) VFS subsystem to implement them as kernel
module.
