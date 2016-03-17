From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Fri, 18 Mar 2016 01:34:01 +0530
Message-ID: <CAG53R5U5f1YBLGuh7Gf7TfbFnrMs+77=8UXKUpKp86oDuGLj7w@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
	<CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
	<CAG53R5Wwr41Ma4AbTG==4VcOGvdO=t=be8z0Lkfq0YukuBtCzg@mail.gmail.com>
	<20160305125215.GC3567@htj.duckdns.org>
	<CAG53R5V-fhbVqZWroAkvDpgjNWchnO87G47-iXqSGg41sY1A5Q@mail.gmail.com>
	<CAG53R5XPFJn-gKvr-WtJy-+zv=APK0DWTBY96fo47XUD9h1FcQ@mail.gmail.com>
	<20160316204002.GG21104@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=KmtO1Wuw5uIj3IsaX3WUdgk5z66X+PVCm7/whD//jZE=;
        b=wOwk4xy/9n2AdVVBWtz9WPB7GeapLKz2AnE3eLy57KGhw8GtPcKIZm5uoUbichxBaJ
         AosGbXaM0ai2QI24u4rsAwfWqwI4z9O5qV/qXhoubdPlQsTGKOHicHzjUz/EDdtNMem4
         Zy0Uk6/KgPhxVDOCHnEqeNCuP60jZ69iNBkORYnBMMNo1NRYf7+fTLQyYhhcWmasXDo/
         bcOnKg5pNwrpOUDKYFewlY3sCIyK12YzKGcI/dNhucTVDfsTuKNQk0B51ZtYIM0VDs5h
         y5N0C8mRPb22fgU11AbrFvZOcMCy6hOCj+qNO8HEZpFwnLz4RUmM5MbHPIoA76sEurur
         BqCA==
In-Reply-To: <20160316204002.GG21104@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun,

On Thu, Mar 17, 2016 at 2:10 AM, Tejun Heo <tj@kernel.org> wrote:
>
>> If this is ok. I will keep the code as it is, because it uses common
>> helper functions for max and current files.
>
> Hmmm... can you please try to refactor the common part to helpers?
> It's not a big thing but there were both styles across different
> controllers and helper based ones tend to be easier to follow.
>
in this v9 patch, To read max and current value, entry point is common
function rdmacg_resource_read().
This is due to the fact that reading max and current needs to do same
thing. Exceptions are taken care
in below helper functions.
It uses two small helper functions
1. get_cg_rpool_values
2. print_rpool_values
Can I continue with this approach?

> I see, but if that's the case, please drop the fine locking.  The fine
> locking doesn't make much sense - as implemented it's slower and the
> whole thing is not hot.

o.k.

Also can you please confirm that once patch looks good to you,
you are ok to merge this patch from Doug's linux-rdma tree as merge is
clean from that tree?
