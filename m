From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Mon, 2 Mar 2020 10:27:09 -0800
Message-ID: <20200302182709.GA527458@carbon.dhcp.thefacebook.com>
References: <20200219183231.50985-1-balejs@google.com>
 <20200229005131.GB9813@google.com>
 <20200229184300.GA484762@carbon.DHCP.thefacebook.com>
 <20200301162003.GA186618@google.com>
 <20200302165330.GA505299@carbon.DHCP.thefacebook.com>
 <CAJuCfpEk4gz9YKVuRBW4E-Up_LSGWCSpyJft4y+rOjyPSa08Zg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=mKd9uf1AgIDe5RNlalxdwF40OJYaXAH05DlEkFeGAsY=;
 b=ixoPNZXaA2QRyu0yDpo4myO+kTuLHe6Qy/5WZdgzJ3L6eZ7ntd8hPWelws79Ec4QXFuC
 5Lfsei94Ek3d7AoRTEkv3xOgA9+jpR2tDjDWk5JJ2/oVk8jJNcLCNgMzF/26tlXmXYGU
 /XF2w1e7SJfNmKhVa6rm/0MYShtDz0Cs1rU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKd9uf1AgIDe5RNlalxdwF40OJYaXAH05DlEkFeGAsY=;
 b=CUzk0WsDAo7GnQn8y7+gAjXpowmapBWEl1tCXmtuwo9JWvMQNtnvQnD5XSG3SOTI1QtsLNopdqHaRXtekksRjslvmG9ep90/bmsA14umZrxE3iiouMoc0O/GupIe7q+f1oxyS0q0NLuuZhqCq0ZOX+8bVfJS5sjOTnhhQEI3w/s=
Content-Disposition: inline
In-Reply-To: <CAJuCfpEk4gz9YKVuRBW4E-Up_LSGWCSpyJft4y+rOjyPSa08Zg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Marco Ballesio <balejs@google.com>, Tejun Heo <tj@kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-doc@vger.kernel.org, linux-pm@vger.kernel.org, Minchan Kim <minchan@google.com>, Daniel Colascione <dancol@google.com>

On Mon, Mar 02, 2020 at 09:46:36AM -0800, Suren Baghdasaryan wrote:
> On Mon, Mar 2, 2020 at 8:53 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Sun, Mar 01, 2020 at 08:20:03AM -0800, Marco Ballesio wrote:
> > > On Sat, Feb 29, 2020 at 10:43:00AM -0800, Roman Gushchin wrote:
> > > > On Fri, Feb 28, 2020 at 04:51:31PM -0800, Marco Ballesio wrote:
> > > > > Hi all,
> > > > >
> > > > > did anyone have time to look into my proposal and, in case, are there
> > > > > any suggestions, ideas or comments about it?
> > > >
> > > > Hello, Marco!
> > > >
> > > > I'm sorry, somehow I missed the original letter.
> > > >
> > > > In general the cgroup v1 interface is considered frozen. Are there any particular
> > > > reasons why you want to extend the v1 freezer rather than use the v2 version of it?
> > > >
> > > > You don't even need to fully convert to cgroup v2 in order to do it, some v1
> > > > controllers can still be used.
> > > >
> > > > Thanks!
> > > >
> > > > Roman
> > >
> > > Hi Roman,
> > >
> > > When compared with backports of v2 features and their dependency chains, this
> > > patch would be easier to carry in Android common. The potential is to have
> > > killability for frozen processes on hw currently in use.
> >
> 
> Hi Roman,
> 
> > I see...
> >
> > The implementation looks good to me, but I really not sure if adding new control files
> > to cgroup v1 is a good idea at this point. Are there any plans in the Android world
> > to move forward to cgroup v2? If not, why not?
> 
> There are plans to prototype that and gradually move from cgroups v1
> to v2 at least for some cgroup controllers (the ones that can use
> unified hierarchy). Creating an additional per-process cgroup v2
> hierarchy only for freezer would be a high price to pay today. In the
> future when we migrate some controllers to v2 the price will be
> amortized and we will probably be able to do that.

I see... Thanks for the explanation, Suren!

Overall the idea of extending the frozen v1 interface looks dubious to me.
Especially if it's only required during the transition to v2.

But of course the decision is on maintainers.

Thanks!
