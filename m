From: Sheng Yang <sheng@yasker.org>
Subject: Re: [PATCH v4 18/21] fuse: Add support for pid namespaces
Date: Wed, 20 Jul 2016 15:28:21 -0700
Message-ID: <CA+2rt423x-EiF=9x2zRTM35hzWOv=rH1urifRTCdpE_p=GO9FQ@mail.gmail.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
 <1461699396-33000-19-git-send-email-seth.forshee@canonical.com>
 <CA+2rt426_pshAauQizcxkfAq16vmEpB4sJ4genW_ucosH3j=zQ@mail.gmail.com> <20160720125201.GA52079@ubuntu-hedt>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yasker-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=trpL7CcXDZ8J+8z9DYe2UCs/acNqBHbLWd0Dxpnvb3s=;
        b=imupu3/phN7aTLUI/aTaIKK6nZkFvIB3ABcgIl4nn+DlrCvVZ6YZ1XmlRfebvu8Qz7
         M/BA5hp6CG2YB66IcxEgq1D2BtvyTM270Ia4Zij4+D8KjFizJPyPS6ozGK86mk5chzBS
         wZKKAmg3azdyk48yaz/pfXF0ZW1F7UIr2hn1Bo5Z8j8CGFZdah/sJK8iOF4TtvqL83GU
         a6vVz6D4ct2CDbrzLJOybAbXVz+DJkqQHOyBFlHuFkXWRonR7crVjM8bUFifGX2bH5LR
         j3eHxgCPERBZUlL2oIHvQ6nLoIfeVWVj975WduwzNTKEyrJmEAC7lYD1K+0+UyvlwmQi
         N/AA==
In-Reply-To: <20160720125201.GA52079@ubuntu-hedt>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, kernel list <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org

On Wed, Jul 20, 2016 at 5:52 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Tue, Jul 19, 2016 at 07:44:11PM -0700, Sheng Yang wrote:
>> On Tue, Apr 26, 2016 at 12:36 PM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > When the userspace process servicing fuse requests is running in
>> > a pid namespace then pids passed via the fuse fd are not being
>> > translated into that process' namespace. Translation is necessary
>> > for the pid to be useful to that process.
>> >
>> > Since no use case currently exists for changing namespaces all
>> > translations can be done relative to the pid namespace in use
>> > when fuse_conn_init() is called. For fuse this translates to
>> > mount time, and for cuse this is when /dev/cuse is opened. IO for
>> > this connection from another namespace will return errors.
>> >
>> > Requests from processes whose pid cannot be translated into the
>> > target namespace are not permitted, except for requests
>> > allocated via fuse_get_req_nofail_nopages. For no-fail requests
>> > in.h.pid will be 0 if the pid translation fails.
>>
>> Hi Seth,
>>
>> This patch caused a regression in our major container use case with
>> FUSE in Ubuntu 16.04, as patch was checked in as Ubuntu Sauce in
>> Ubuntu 4.4.0-6.21 kernel.
>>
>> The use case is:
>> 1. Create a Docker container.
>> 2. Inside the container, start the FUSE backend, and mounted fs.
>> 3. Following step 2 in the container, create a loopback device to map
>> a file in the mounted fuse to create a block device, which will be
>> available to the whole system.
>>
>> It works well before this commit.
>>
>> The use case is broken because no matter which namespace losetup runs,
>> the real request from loopback device seems always come from init ns,
>> thus it will be in different ns running fuse backend. So the request
>> will got denied, because the ns running fuse won't able to see the
>> things from higher level(level 0 in fact) pid namespace.
>>
>> I think since init pid ns has ability to access any process in the
>> system, it should able to access the fuse mounted by any pid namespace
>> process as well.
>>
>> What you think?
>
> It sounds like we need to remove the restriction on accessing the
> filesystem from a different pid namespace. I don't think this poses a
> security problem. However there's no pid mapping that is usable by the
> userspace fuse process, so what do we put in the fuse request? Probably
> the only candidates are 0 and 0xffffffff.

Thanks Seth, I don't think it will be a security problem either, if we
remove the restriction.

>
> So a question for the fuse developers - is one value or the other
> preferrable for fuse_in_header.pid when the pid cannot be mapped, and is
> this going to cause problems for any fuse filesystems? I suspect that
> few filesystems actually look at the pid anyway, and already for a
> filesystem mounted in a pid namespace the values being given to
> userspace won't be correct for the namespace of the fuse process.
>

At least in our system we're not looking into the pid at all.

--Sheng

> Seth
>
