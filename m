From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: [PATCH] block: transfer source bio's cgroup tags to
 clone via bio_associate_blkcg() (was: Re: blkio cgroups controller doesn't
 work with LVM?)
Date: Wed, 2 Mar 2016 22:19:38 +0200
Message-ID: <CAJFSNy6MUGr8E3RNw6hFiskcaG4m8EGdqMkQXVh1LGq-yZCjBg@mail.gmail.com>
References: <56CDF283.9010802@windriver.com> <56CEB1BC.4000005@kyup.com>
	<20160225145314.GA20699@redhat.com>
	<20160302160649.GB29826@mtj.duckdns.org>
	<20160302175656.GA59991@redhat.com>
	<CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w@mail.gmail.com>
	<20160302191827.GC3476@redhat.com>
	<CAJFSNy7E9b06JQOdjzKDpz5Ehks4ZZ1disfN2U-RQxJnSwyqZw@mail.gmail.com>
	<20160302201016.GE3476@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8749048365506278639=="
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=siteground-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to
	:cc; bh=FxTWn0qGJaNzIKI4y00V+MpdQfO2hE8Fb3KZkIJGeCU=;
	b=sZSuqbAnpMSerAtpfEh0Mj7od8BSVCSSH9YpzP5qAL2wmcW3zi+deRC610w03Ulh+6
	8EhMvn8Uo+WIPbkN65DgumhAcIkGO+5y/x45+PuO60FLXVNDZNJEBIgvsRzKB/BlvUUU
	BWcndtQcaAvIc8wvj+kV4LzQfSUJO+Cy16F5/uxLR1BslteeiYtIBTrBYzqkDH2iJYTM
	gEBUrrO7WJRHmTQo2rOkG84a6H58C4mFh+ygtGXx/gFbKPdSQ/Rl9NOY/wIbAPd7obNR
	48vsKtFWQTQ5Eg7Rn5bEVMBckCWlau7ejYknSbGi1EdcS6mUMwuvccvZ/kBHgf5kkdRa
	9fdw==
In-Reply-To: <20160302201016.GE3476@redhat.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, SiteGround Operations <operations@siteground.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Nikolay Borisov <kernel@kyup.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Chris Friesen <chris.friesen@windriver.com>

--===============8749048365506278639==
Content-Type: multipart/alternative; boundary=001a1134f846ed94cc052d16995a

--001a1134f846ed94cc052d16995a
Content-Type: text/plain; charset=UTF-8

On Wednesday, March 2, 2016, Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Mar 02, 2016 at 09:59:13PM +0200, Nikolay Borisov wrote:
> > On Wednesday, March 2, 2016, Vivek Goyal <vgoyal@redhat.com
> <javascript:;>> wrote:
> >
> > > On Wed, Mar 02, 2016 at 08:03:10PM +0200, Nikolay Borisov wrote:
> > > > Thanks for the patch I will likely have time to test this sometime
> next
> > > week.
> > > > But just to be sure - the expected behavior would be that processes
> > > > writing to dm-based devices would experience the fair-shair
> > > > scheduling of CFQ (provided that the physical devices that back those
> > > > DM devices use CFQ), correct?
> > >
> > > Nikolay,
> > >
> > > I am not sure how well it will work with CFQ of underlying device. It
> will
> > > get cgroup information right for buffered writes. But cgroup
> information
> >
> >
> >  Right, what's your definition of  buffered writes?
>
> Writes which go through page cache.
>
> > My mental model is that
> > when a process submits a write request to a dm device , the bio is going
> to
> > be put on a devi e workqueue which would then  be serviced by a
> background
> > worker thread and later the submitter notified. Do you refer to this
> whole
> > gamut of operations as buffered writes?
>
> No, once the bio is submitted to dm device it could be a buffered write or
> a direct write.
>
> >
> > for reads and direct writes will come from submitter's context and if dm
> > > layer gets in between, then many a times submitter might be a worker
> > > thread and IO will be attributed to that worker's cgroup (root cgroup).
> >
> >
> > Be that as it may, proivded that the worker thread is in the  'correct'
> > cgroup,  then the appropriate babdwidth policies should apply, no?
>
> Worker thread will most likely be in root cgroup. So if a worker thread
> is submitting bio, it will be attributed to root cgroup.
>
> We had similar issue with IO priority and it did not work reliably with
> CFQ on underlying device when dm devices were sitting on top.
>
> If we really want to give it a try, I guess we will have to put cgroup
> info of submitter early in bio at the time of bio creation even for all
> kind of IO. Not sure if it is worth the effort.
>
> For the case of IO throttling, I think you should put throttling rules on
> the dm device itself. That means as long as filesystem supports the
> cgroups, you should be getting right cgroup information for all kind of
> IO and throttling should work just fine.


Throttling does work even now,  but the use case I had in mind was
proportional
distribution of IO. Imagine 50  or so dm devices, hosting IO intensive
workloads. In
this situation, I'd  be interested each of them getting proportional IO
based on the weights
set in the blkcg controller for each respective cgroup for every workload.

>
> Thanks
> Vivek
>

--001a1134f846ed94cc052d16995a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Wednesday, March 2, 2016, Vivek Goyal &lt;<a href=3D"mailto:vgoy=
al@redhat.com">vgoyal@redhat.com</a>&gt; wrote:<br><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">On Wed, Mar 02, 2016 at 09:59:13PM +0200, Nikolay Borisov wrote:<br>
&gt; On Wednesday, March 2, 2016, Vivek Goyal &lt;<a href=3D"javascript:;" =
onclick=3D"_e(event, &#39;cvml&#39;, &#39;vgoyal@redhat.com&#39;)">vgoyal@r=
edhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Wed, Mar 02, 2016 at 08:03:10PM +0200, Nikolay Borisov wrote:<=
br>
&gt; &gt; &gt; Thanks for the patch I will likely have time to test this so=
metime next<br>
&gt; &gt; week.<br>
&gt; &gt; &gt; But just to be sure - the expected behavior would be that pr=
ocesses<br>
&gt; &gt; &gt; writing to dm-based devices would experience the fair-shair<=
br>
&gt; &gt; &gt; scheduling of CFQ (provided that the physical devices that b=
ack those<br>
&gt; &gt; &gt; DM devices use CFQ), correct?<br>
&gt; &gt;<br>
&gt; &gt; Nikolay,<br>
&gt; &gt;<br>
&gt; &gt; I am not sure how well it will work with CFQ of underlying device=
. It will<br>
&gt; &gt; get cgroup information right for buffered writes. But cgroup info=
rmation<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 Right, what&#39;s your definition of=C2=A0 buffered writes?<br>
<br>
Writes which go through page cache.<br>
<br>
&gt; My mental model is that<br>
&gt; when a process submits a write request to a dm device , the bio is goi=
ng to<br>
&gt; be put on a devi e workqueue which would then=C2=A0 be serviced by a b=
ackground<br>
&gt; worker thread and later the submitter notified. Do you refer to this w=
hole<br>
&gt; gamut of operations as buffered writes?<br>
<br>
No, once the bio is submitted to dm device it could be a buffered write or<=
br>
a direct write.<br>
<br>
&gt;<br>
&gt; for reads and direct writes will come from submitter&#39;s context and=
 if dm<br>
&gt; &gt; layer gets in between, then many a times submitter might be a wor=
ker<br>
&gt; &gt; thread and IO will be attributed to that worker&#39;s cgroup (roo=
t cgroup).<br>
&gt;<br>
&gt;<br>
&gt; Be that as it may, proivded that the worker thread is in the=C2=A0 &#3=
9;correct&#39;<br>
&gt; cgroup,=C2=A0 then the appropriate babdwidth policies should apply, no=
?<br>
<br>
Worker thread will most likely be in root cgroup. So if a worker thread<br>
is submitting bio, it will be attributed to root cgroup.<br>
<br>
We had similar issue with IO priority and it did not work reliably with<br>
CFQ on underlying device when dm devices were sitting on top.<br>
<br>
If we really want to give it a try, I guess we will have to put cgroup<br>
info of submitter early in bio at the time of bio creation even for all<br>
kind of IO. Not sure if it is worth the effort.<br>
<br>
For the case of IO throttling, I think you should put throttling rules on<b=
r>
the dm device itself. That means as long as filesystem supports the<br>
cgroups, you should be getting right cgroup information for all kind of<br>
IO and throttling should work just fine.</blockquote><div><br></div><div>Th=
rottling does work even now, =C2=A0but the use case I had in mind was propo=
rtional=C2=A0</div><div>distribution of IO. Imagine 50 =C2=A0or so dm devic=
es, hosting IO intensive workloads. In</div><div>this situation, I&#39;d =
=C2=A0be interested each of them getting proportional IO based on the weigh=
ts</div><div>set in the blkcg controller for each respective cgroup for eve=
ry workload.</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Thanks<br>
Vivek<br>
</blockquote>

--001a1134f846ed94cc052d16995a--


--===============8749048365506278639==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8749048365506278639==--
