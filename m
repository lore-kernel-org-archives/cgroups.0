From: Roman Gushchin <guro@fb.com>
Subject: Re: PROBLEM: cgroup cost too much memory when transfer small files
 to tmpfs
Date: Tue, 21 Jul 2020 12:27:49 -0700
Message-ID: <20200721192749.GB8266@carbon.DHCP.thefacebook.com>
References: <2E04DD7753BE0E4ABABF0B664610AD6F2620CAF7@dggeml528-mbx.china.huawei.com>
 <20200721174126.GA271870@cmpxchg.org>
 <20200721184959.GA8266@carbon.DHCP.thefacebook.com>
 <CALvZod6-sTBMzvo0ER+RkQ_OM7B4=PKUC-T9gXmQiB8mznunBg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wP1rcjYzY+zqZYZFuAG3LTgRFambuN6uLhhtU+vtj4I=;
 b=VM+WdZ4/ST0cS//LaJSBiPRq+tuMT7nC4iSJMudUo9gbglQPtUYGrdbuA9L3oLwPK1CU
 d1biamqBYRrMbMT93/7IkQ7RyW5mUUFnWUdJj8CK45wrqwQEIawa9OLnp8fPeKT8iynr
 EBMsiVvy/VK5xltiznlKfRuK+QkSrkiNgCc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wP1rcjYzY+zqZYZFuAG3LTgRFambuN6uLhhtU+vtj4I=;
 b=MzzVj7DR93dYn4CLbscftImopNAZ1T5aJlJbOZ9NL2mvxFbAEADD8B9XYEamgFR5oRtMf190rFsaNo03H51oU72E9gwO2AFqsgGp0mVAnyD/fB9gB01s/D6QKd9OFwXVVgRKOl+LxlDMtPjQd+DnaJZVrk09eWHs9Uv7EyLMSR8=
Content-Disposition: inline
In-Reply-To: <CALvZod6-sTBMzvo0ER+RkQ_OM7B4=PKUC-T9gXmQiB8mznunBg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, jingrui <jingrui@huawei.com>, "tj@kernel.org" <tj@kernel.org>, Lizefan <lizefan@huawei.com>, "mhocko@kernel.org" <mhocko@kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, caihaomin <caihaomin@huawei.com>, "Weiwei (N)" <wick.wei@huawei.com>, guro@cmpxchg.org

On Tue, Jul 21, 2020 at 12:12:58PM -0700, Shakeel Butt wrote:
> On Tue, Jul 21, 2020 at 11:51 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Tue, Jul 21, 2020 at 01:41:26PM -0400, Johannes Weiner wrote:
> > > On Tue, Jul 21, 2020 at 11:19:52AM +0000, jingrui wrote:
> > > > Cc: Johannes Weiner <hannes@cmpxchg.org> ; Michal Hocko <mhocko@kernel.org>; Vladimir Davydov <vdavydov.dev@gmail.com>
> > > >
> > > > Thanks.
> > > >
> > > > ---
> > > > PROBLEM: cgroup cost too much memory when transfer small files to tmpfs.
> > > >
> > > > keywords: cgroup PERCPU/memory cost too much.
> > > >
> > > > description:
> > > >
> > > > We send small files from node-A to node-B tmpfs /tmp directory using sftp. On
> > > > node-B the systemd configured with pam on like below.
> > > >
> > > > cat /etc/pam.d/password-auth | grep systemd
> > > > -session     optional      pam_systemd.so
> > > >
> > > > So when transfer a file, a systemd session is created, that means a cgroup is
> > > > created, then file saved at /tmp will associated with a cgroup object. After
> > > > file transferred, session and cgroup-dir will be removed, but the file in /tmp
> > > > still associated with the cgroup object. The PERCPU memory in cgroup/css object
> > > > cost a lot(about 0.5MB/per-cgroup-object) on 200/cpus machine.
> > >
> > > CC Roman who had a patch series to free all this extended (percpu)
> > > memory upon cgroup deletion:
> > >
> > > https://lore.kernel.org/patchwork/cover/1050508/
> > >
> > > It looks like it never got merged for some reason.
> >
> > The mentioned patchset can make the problem less noticeable, but can't solve it completely.
> > It has never been merged, because the dying cgroup problem was mostly solved by other methods:
> > slab memory reparenting and various reclaim fixes. So there was no more reason to complicate
> > the code to release the memcg memory early.
> >
> > The overhead of creating and destroying a new memory cgroup for a transfer of a small
> > file will be noticeable anyway. So IMO the solution is to use a single cgroup for all
> > transfers. I don't know if systemd supports such mode out of the box, but it shouldn't
> > be hard to add it.
> >
> > But also I wonder if we need a special tmpfs mount option, something like "noaccount".
> > Not only for this specific case, but also for the case when tmpfs is extensively
> > shared between multiple cgroups or if it's used to pass some data from one cgroup
> > to another, or if we care about the performance more than about the accounting;
> > in other words for cases where the accounting makes more harm than good.
> >
> 
> Internally we actually have an tmpfs mount option "memcg=" which
> charges all the memory of the tmpfs files on that mount to the given
> memcg and the motivation is the shared tmpfs files between multiple
> cgroups. One concrete use-case is the shared memory used for
> communication between the application and the user space network
> driver [1]. The "memcg=root" can be used as a "noaccount" option.

It sounds like a good idea to me. I'm slightly worried about possible
security implications of allowing to pass a custom cgroup, but I guess
we can start with supporting the root cgroup only.

Thanks!
