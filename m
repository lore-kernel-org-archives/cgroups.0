From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4 03/21] fs: Allow sysfs and cgroupfs to share super blocks between user namespaces
Date: Wed, 18 May 2016 11:27:12 -0500
Message-ID: <87bn43qqlb.fsf@x220.int.ebiederm.org>
References: <1461699046-30485-1-git-send-email-seth.forshee@canonical.com>
	<1461699046-30485-4-git-send-email-seth.forshee@canonical.com>
	<87shxgxqai.fsf@x220.int.ebiederm.org>
	<20160517235834.GA104031@ubuntu-hedt>
	<8760ubs738.fsf@x220.int.ebiederm.org>
	<20160518161618.GC129218@ubuntu-hedt>
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160518161618.GC129218@ubuntu-hedt> (Seth Forshee's message of
	"Wed, 18 May 2016 11:16:18 -0500")
Sender: linux-bcache-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Wed, May 18, 2016 at 10:45:31AM -0500, Eric W. Biederman wrote:
>> > But if we do that it violates some of the assumptions of the patch to
>> > rework MNT_NODEV on your testing branch (and also those behind patch 2
>> > in this series). Something will need to be changed there to prevent a
>> > regression in mount behavior when a user ns tries to mount without
>> > MNT_NODEV when the mount inherited from its parent has it set.
>> 
>> Thank you for pointing that out.  I will look into that.
>> 
>> I believe I know exactly what you are talking about.  Of the choices I
>> think it is better to a minor localized change in the fs_fully_visible
>> logic than it is to cause problems elsewhere.
>
> Agreed.
>
>> >> Apologies for not catching this earlier.
>> >
>> > Actually this is a more recent patch, so you possibly hadn't seen it
>> > before.
>> >
>> >> I am looking at folding all of this into the patch that introduces
>> >> sget_userns so that even bisects won't have regresssions.
>> >
>> > That's fine with me.
>> 
>> And thank you for keeping everything as separate patches.  That is at
>> least helping me catch up.  Even if I don't agree that these things
>> should be separate come merge time.
>
> Honestly I probably would have squashed some of them into that first
> patch myself if you hadn't already applied it to your testing branch, so
> that's all just luck.
>
> Keep in mind that I also have that patch for mqueue that isn't in this
> series, and I haven't yet checked to see if the 4.7 merges introduce
> anything which is going to require updating these patches. I was
> planning to wait and send out updates after -rc1, but if you want that
> stuff sooner just let me know.

As unfortunately I don't have anything going into -rc1 I am working on
this right now.

Let me finish sorting out the sget_userns and mnt nodev mess and I will
push something out and then we can compare notes.  I think I have mqueue
covered by other changes.  As it is in the set of filesystems that
should just use sget_userns.

I am sorting through the nodev corner of this now.  It should just be a
day or two.

Eric
