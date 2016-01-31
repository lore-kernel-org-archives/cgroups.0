From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Sun, 31 Jan 2016 23:20:45 +0530
Message-ID: <CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw@mail.gmail.com>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
	<1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
	<20160130183015.GP32380@htj.duckdns.org>
	<CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
	<20160131100237.GS32380@htj.duckdns.org>
	<CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
	<20160131110420.GV32380@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=0tQudTUBKu2pFLanWLk3v0T48zaATBODRk2k4q+aqGM=;
        b=MDryZP3Ff0iGwWA1Zu81EDfSwlImwarXSebbbiYUU4iq7VlPUUjIUMUfKMhbxQknK5
         NKkbUoAQ3JtbUADM8/gWMREX0clbNoWvvAMLrfTaapZP7rgU1mrkQ4BcoOq1APXm2+4E
         /oGPkZmVMEMsm7mwErCJiqNSyuKHREst6OWhwMNJVJg0FxJTMK4iNld3aLVQWsgMPR6J
         zCx71qFqIq5RpEFT5/fEJu5irmHTSRetFIFndL5Abficb/4VL/ObMyrmSssrow45BZjh
         myUBUg3uBNes5PTV1lPnh+Hb355FI1IwX67wOib75n6xoY3TaMxCrQJsBKNxka/5Ybcd
         FKGw==
In-Reply-To: <20160131110420.GV32380@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Doug, Liran, Jason,

How would you like to see RDMA verb resources being defined - in RDMA
cgroup or in IB stack?
In current patch v5, its defined by the IB stack which is often
shipped as different package due to high amount of changes, bug fixes,
features.
In v0 patch it was defined by the RDMA cgroup, which means any new
resource addition/definition requires kernel upgrade. Which is hard to
change often.
If resources are defined by RDMA cgroup kernel than adding/removing
resource means, someone have to do lot of engineering with different
versions of kernel support and loadable module support using compat.h
etc at driver level, which in my mind is some amount of engineering
compare to what v5 has to offer and its already available. With one
round of cleanup in resource definition, it should be usable.

Its important to provide this feedback to Tejun and me, so that we
take informed design decision.

Hi Tejun,

On Sun, Jan 31, 2016 at 4:34 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Sun, Jan 31, 2016 at 04:11:54PM +0530, Parav Pandit wrote:
>> No. We agreed that let IB stack define in the header file that rdmacg
>> can include.
>> However when I started with that I realized that, such design has
>> basic flaw that IB stack is compiled as loadable modules.
>> cgroup which is compiled along with kernel, cannot rely on the header
>> file of the loadable module, as it will lead to incompatibly and
>> possible crash.
>
> Yes, it can.  It just becomes a part of kernel ABI that the IB stack
> module depends on.
>
o.k. Its doable, but I believe its simple but its restrictive.
If rest of the RDMA experts are ok with it, I will change it to do it that way.
We get to hear their feedback before we put this as ABI.

>> > Keep the resource types in an array in minimal way and match with the
>> > information from core side.  It doesn't make any sense to use match
>> > tokens in defining resources when the resource type is always fixed.
>> >
>> Match token is being used in other places also typically where user
>> configuration is involved.
>> so Match token infrastructure APIs help to avoid rewriting parser.
>> What exactly is the issue in using match token?
>> Resource type is fixed - sure it is with given version of loadable
>> module. But if new feature/resource is added in IB stack, at that
>> point new token will be added in the array.
>
> Sure, use parser for parsing but you end up stripping =%d in other
> places anyway.  Do it the other way.  Let the definitions contain
> what's essential and do the extra stuff in code handling it, not the
> other way around.
>
>> Now coming to remove command's need.
>> If user has previously configured limit of say mr=15. Now if wants to
>> remove that configuration and don't want to bother for the limit.
>> So the way, its done is by issuing "remove" command.
>> Should I name is "reset".
>
> How is this different from setting the limits to max?
>
We can set it to max. But during freeing time, checking array of 10+
elements whether its max or not, didn't find efficient either.

>> When user issues "remove" command it could still happen that there are
>> active rdma resources. So we cannot really free the rpool object.
>> That is freed when last resource is uncharged.
>> Make sense?
>
> Not really.
>
>> > You're re-stating the same thing without explaining the reasoning
>> > behind it.  Why is this different from other controllers?  What's the
>> > justification?
>>
>> As in above example of 15-85, if we keep it or create is we will end
>> up allocating rpool objects for all the 100 cgroups, which might not
>> be necessary. If it happens to be multi level hierarchy, it will end
>> up having in each level.
>> So therefore its allocated and freed dynamically.
>
> Just keeping them around till device destruction would work just fine.

Most likely not. I tried to explained that in reply to Haggai's email
for RFC, also in rdma.txt documentation patch 3/3.
Let me try again.
Device stays in a system for long time. Mostly for months until
drivers are unloaded or firmware crashes or some other event.
While on other hand, cgroup life cycle is in hours or more.
So rpool that we allocated dynamically, it needs to be freed or
atleast when set to max or when cgroup is deleted.
But there is catch there, it cannot be freed because there are
processed which has allocated the resource from this cgroup, but have
been migrated to other cgroup which will uncharge sometime later.
(This is not a usecase, but its the artifact of cgroup interface).
So rpool needs to be freed at later when uncharge occurs. At that
point we drop the reference to the css, so that css can be freed and
same css->id can get circulated for new cgroup.
If we don't do this, and wait until device destruction, rpool just
keeps growing!
I think above is more important design aspect than just saving memory to me.

Let me know if you have different design thought here.
(Like engineering can_attach() callback in rdma_cgroup, which I don't
see necessary either).

> If you wanna insist on freeing them dynamically, free them when both
> their usages and configs are nil.
Agree. Thats what the code is doing using marking object type being default.
If I remove the object type, as alternative,
It requires that when we uncharge resource, we should run through the
max array to see if they are all set to max.
And keep one aggregate counter for usage (apart from individual)
counter for each resource.

> How the object is created shouldn't be a factor.

Loop for max and aggregate counter can avoid creator variable.

>
>> If its created by user configuration, and if we free the rpool object
>> when last resource is freed which is holding the configuration,
>> user configuration is lost.
>> Also it doesn't make much sense to have two different allocation for
>> limit and usage configuration. Pointer storing overhead is more than
>> the actual content.
>
> See above.  If you want to free dynamically, free when the thing
> doesn't contain any information.
o.k.

> Better, just don't worry about it. It's unlikely to matter.
I tried to explain above about the need to free dynamically, instead
of device destruction time.

>
>> > No, the locking scheme doesn't make any sense.  Except for some
>> > special cases, sequence like the following indicates that the code is
>> > buggy or at least silly.
>> >
>> Help me to understand, silly means - unacceptable?
>
> Yes, it's a clear anti-pattern for a refcnted object.  Again, just
> push the locking to the users and drop the atomics.
>
ok. Let me see how can I refactor this part of code. I will get back
on this if I hit a block.


>> Why you don't want them to be freed when there are no requester
>> allocating the resource?
>> Device usually stays for longer time, but applications go way and come
>> back more often, so freeing them makes more sense when not in use.
>> What exactly is the problem in freeing when uncharing occurs, due to
>> which I should defer it to device unregistration stage?
>
> Two things.  Freeing dynamically doesn't require creator type or
> refcnting here, so the code makes no sense to me.  It's complicated
> without any purpose.  Second, it's not that big a struct.  Just leave
> them around till it's clear that this is problematic.
Above explanation should justify that its problematic to keep that
around until device destruction.

> For the Nth time in this whole thing, keep things simple.  Stop overengineering.

I have tried to keep in simple. I respect your comments and have
improved upon most of the valuable comments that you gave in
subsequent patches from v0 to v5.
Few exceptions which I will work through now are:
1. resource definition place (cgroup vs IB stack) - avoid callback.
2. lock functions
3. dynamic freeing (which I think is justified now above).
