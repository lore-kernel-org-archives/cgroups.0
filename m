From: Weijie Yang <weijieut@gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTog562U5aSNOiBsb3cgbWVtb3J5IGtpbGxlcg==?=
Date: Thu, 20 Nov 2014 22:19:05 +0800
Message-ID: <CABdxLJGViULvRt7nptNzYZN3E7szN3k4BvQAMUrJ7oMBNcoOoQ@mail.gmail.com>
References: <AF7C0ADF1FEABA4DABABB97411952A2EC91E38@CN-MBX02.HTC.COM.TW>
	<20141120095802.GA24575@dhcp22.suse.cz>
	<AF7C0ADF1FEABA4DABABB97411952A2EC91EF5@CN-MBX02.HTC.COM.TW>
	<20141120101855.GB24575@dhcp22.suse.cz>
	<AF7C0ADF1FEABA4DABABB97411952A2EC91FE0@CN-MBX02.HTC.COM.TW>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=047d7bd761d6c8249205084b020e
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Zxhz/rxO3TkBKN5xmWccXrPol8XR2w3SItrrvd42jEk=;
        b=KG97O9BKDQlLmwvLPcnLmlvoQWOg7AYFFy0SdzJn46+1ORCHP9cAdYnnIQ3l+SGbPp
         zqFWC0PbvfyDMvUuvWxnSO6d/6FZ939n+I5Tbu7zK1UW4q7GD2LMr+kqxEKxOoy9rVtC
         cAsD8FKLwSvVpMdSAS3E8wdutYUwXHCVGGCu7d3whGNpKwjSLZoHiiGFHnxuFHjmo2hi
         eojRwO1rgCud0zLYpTkIg/7dizRamBF9N5TuIMxS4ogU42n2ir2h5t83VK7bVeKnn19e
         p4Si6mAMRQzF1sSIbgZpBCST4pQpIUNUDiJzrp8ObP/EY2oReOJU3FKb0aP3gLtL/2zs
         9yMA==
In-Reply-To: <AF7C0ADF1FEABA4DABABB97411952A2EC91FE0@CN-MBX02.HTC.COM.TW>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
To: zhiyuan_zhu@htc.com
Cc: mhocko@suse.cz, hannes@cmpxchg.org, Future_Zhou@htc.com, Rachel_Zhang@htc.com, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, greg@kroah.com, Sai_Shen@htc.com

--047d7bd761d6c8249205084b020e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2014 at 8:05 PM, <zhiyuan_zhu@htc.com> wrote:

> Hi Greg/Michal
> Very sorry I have a mistake in previous mail. (It should be nr_file_pages=
 not nr_free_pages)
> I rearrange this problem.
>
> // *********** log begin **********
> 6      161030.084144       2014-11-07 21:44:53.304        lowmemorykiller=
: Killing 'om.htc.launcher' (4486), adj 294,
> 6      161030.084144       2014-11-07 21:44:53.304           to free 4785=
6kB on behalf of 'kworker/u8:14' (20594) because
> 6      161030.084144       2014-11-07 21:44:53.304           cache 72460k=
B is below limit 73728kB for oom_score_adj 235
> //  **** /proc/meminfo 's result
> 4      161030.084797       2014-11-07 21:44:53.304        Cached:        =
   142448 kB
> // *********** log end **********
>
> After I checked the android's low memory strategy: kernel/drivers/staging=
/android/lowmemorykiller.c
>
> // ****** code begin *********
> other_file =3D global_page_state(NR_FILE_PAGES) -
> global_page_state(NR_SHMEM) -
> total_swapcache_pages();
>
> lowmem_print(1, "Killing '%s' (%d), adj %hd,\n" \
> "   to free %ldkB on behalf of '%s' (%d) because\n" \
> "   cache %ldkB is below limit %ldkB for oom_score_adj %hd\n" \
> "   Free memory is %ldkB above reserved\n",
>      selected->comm, selected->pid,
>      selected_oom_score_adj,
>      selected_tasksize * (long)(PAGE_SIZE / 1024),
>      current->comm, current->pid,
>      other_file * (long)(PAGE_SIZE / 1024),
>      minfree * (long)(PAGE_SIZE / 1024),
>      min_score_adj,
>      other_free * (long)(PAGE_SIZE / 1024));
> // ******* code end ************
>
> So android's strategy's free memory is =3D other_file =3D (nr file pages =
- nr shmem - total swapcache pages) * 4K =3D [cache 72460kB]
> But the system's free memory is: Cached:        142448 kB  // from /proc/=
meminfo
>
> And system's free memory is: Cached + MemFree + Buffers is largely than t=
he memory which anroid lowmemorykiller calculated memory [cache 72460K]
> At this time point, system will kill some important processes, but system=
 have enough memory.
> This is android's lowmemorykiller defect? or Linux kernel memory's defect=
?
>
> So I have some questions:
> I have a question: what's the nr file pages mean? What different between =
nr_file_pages from Cached (from /proc/meminfo)?
> And nr shmem, swapcache pages are small, so I think this is the key probl=
em why android's stragegy calculated free memory is largely less than /proc=
/meminfo Cached's value.
>
>
Why lowmemkiller -total_swapcache_pages()? see commit 058dbde92:

staging: android: lowmemorykiller: neglect swap cached pages in other_file
With ZRAM enabled it is observed that lowmemory killer
doesn't trigger properly. swap cached pages are
accounted in NR_FILE, and lowmemorykiller considers
this as reclaimable and adds to other_file. But these
pages can't be reclaimed unless lowmemorykiller triggers.
So subtract swap pages from other_file.


and commit 31d59a4198f will also make help, please check it.


> Thanks
> Zhiyuan zhu
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Michal Hocko [mailto:mhocko@suse.cz]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2014=E5=B9=B411=E6=9C=8820=E6=97=A5=
 18:19
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Zhiyuan Zhu(=E6=9C=B1=E5=BF=97=E9=81=A0)
> =E6=8A=84=E9=80=81: hannes@cmpxchg.org; Future Zhou(=E5=91=A8=E6=9C=AA=E4=
=BE=86); Rachel Zhang(=E5=BC=B5=E7=91=A9); bsingharora@gmail.com; kamezawa.=
hiroyu@jp.fujitsu.com; cgroups@vger.kernel.org; linux-mm@kvack.org; greg@kr=
oah.com
> =E4=B8=BB=E9=A2=98: Re: =E7=AD=94=E5=A4=8D: low memory killer
>
> On Thu 20-11-14 10:09:25, zhiyuan_zhu@htc.com wrote:
> > Hi Michal
> > Thanks for your kindly support.
> > I got a device, and dump the /proc/meminfo and /proc/vmstat files,
> > they are the Linux standard proc files.
> > I found that: Cached =3D 339880 KB, but nr_free_pages=3D14675*4 =3D 587=
00KB
> > and nr_shmem =3D 508*4=3D2032KB
> >
> > nr_shmem is just a little memory, and nr free pages + nr_shmem is
> > largely less than Cached.  So why nr_free_pages is largely less than
> > Cached? Thank you.
>
> nr_free_pages refers to pages which are not allocated. Cached referes to =
a used memory which is easily reclaimable so it can be reused should there =
be a need and free memory drops down. So this is a normal situation. How is=
 this related to the lowmemory killer question posted previously?
>
> [...]
> --
> Michal Hocko
> SUSE Labs
>
>
> CONFIDENTIALITY NOTE : The information in this e-mail is confidential and
> privileged; it is intended for use solely by the individual or entity nam=
ed
> as the recipient hereof. Disclosure, copying, distribution, or use of the
> contents of this e-mail by persons other than the intended recipient is
> strictly prohibited and may violate applicable laws. If you have received
> this e-mail in error, please delete the original message and notify us by
> return email or collect call immediately. Thank you. HTC Corporation
>

--047d7bd761d6c8249205084b020e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 20, 2014 at 8:05 PM,  <span dir=3D"ltr">&lt;<a href=3D"mailto:zhiyu=
an_zhu@htc.com" target=3D"_blank">zhiyuan_zhu@htc.com</a>&gt;</span> wrote:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:sol=
id;padding-left:1ex"><pre>Hi Greg/Michal
Very sorry I have a mistake in previous mail. (It should be nr_file_pages n=
ot nr_free_pages)
I rearrange this problem.

// *********** log begin **********
6      161030.084144       2014-11-07 21:44:53.304        lowmemorykiller: =
Killing &#39;om.htc.launcher&#39; (4486), adj 294,
6      161030.084144       2014-11-07 21:44:53.304           to free 47856k=
B on behalf of &#39;kworker/u8:14&#39; (20594) because
6      161030.084144       2014-11-07 21:44:53.304           cache 72460kB =
is below limit 73728kB for oom_score_adj 235
//  **** /proc/meminfo &#39;s result
4      161030.084797       2014-11-07 21:44:53.304        Cached:          =
 142448 kB
// *********** log end **********

After I checked the android&#39;s low memory strategy: kernel/drivers/stagi=
ng/android/lowmemorykiller.c

// ****** code begin *********
other_file =3D global_page_state(NR_FILE_PAGES) -
global_page_state(NR_SHMEM) -
total_swapcache_pages();

lowmem_print(1, &quot;Killing &#39;%s&#39; (%d), adj %hd,\n&quot; \
&quot;   to free %ldkB on behalf of &#39;%s&#39; (%d) because\n&quot; \
&quot;   cache %ldkB is below limit %ldkB for oom_score_adj %hd\n&quot; \
&quot;   Free memory is %ldkB above reserved\n&quot;,
     selected-&gt;comm, selected-&gt;pid,
     selected_oom_score_adj,
     selected_tasksize * (long)(PAGE_SIZE / 1024),
     current-&gt;comm, current-&gt;pid,
     other_file * (long)(PAGE_SIZE / 1024),
     minfree * (long)(PAGE_SIZE / 1024),
     min_score_adj,
     other_free * (long)(PAGE_SIZE / 1024));
// ******* code end ************

So android&#39;s strategy&#39;s free memory is =3D other_file =3D (nr file =
pages - nr shmem - total swapcache pages) * 4K =3D [cache 72460kB]
But the system&#39;s free memory is: Cached:        142448 kB  // from /pro=
c/meminfo

And system&#39;s free memory is: Cached + MemFree + Buffers is largely than=
 the memory which anroid lowmemorykiller calculated memory [cache 72460K]
At this time point, system will kill some important processes, but system h=
ave enough memory.
This is android&#39;s lowmemorykiller defect? or Linux kernel memory&#39;s =
defect?

So I have some questions:
I have a question: what&#39;s the nr file pages mean? What different betwee=
n nr_file_pages from Cached (from /proc/meminfo)?
And nr shmem, swapcache pages are small, so I think this is the key problem=
 why android&#39;s stragegy calculated free memory is largely less than /pr=
oc/meminfo Cached&#39;s value.</pre></blockquote><div><br></div><div>Why lo=
wmemkiller -total_swapcache_pages()? see commit=C2=A0058dbde92:</div><div><=
br></div><div><div>staging: android: lowmemorykiller: neglect swap cached p=
ages in other_file</div><div>With ZRAM enabled it is observed that lowmemor=
y killer</div><div>doesn&#39;t trigger properly. swap cached pages are</div=
><div>accounted in NR_FILE, and lowmemorykiller considers</div><div>this as=
 reclaimable and adds to other_file. But these</div><div>pages can&#39;t be=
 reclaimed unless lowmemorykiller triggers.</div><div>So subtract swap page=
s from other_file.</div><div><br></div></div><div><br></div><div>and commit=
=C2=A031d59a4198f will also make help, please check it.</div><div>=C2=A0</d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:soli=
d;padding-left:1ex"><pre>Thanks
Zhiyuan zhu

-----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
=E5=8F=91=E4=BB=B6=E4=BA=BA: Michal Hocko [mailto:<a href=3D"mailto:mhocko@=
suse.cz" target=3D"_blank">mhocko@suse.cz</a>]=20
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2014=E5=B9=B411=E6=9C=8820=E6=97=A5 1=
8:19
=E6=94=B6=E4=BB=B6=E4=BA=BA: Zhiyuan Zhu(=E6=9C=B1=E5=BF=97=E9=81=A0)
=E6=8A=84=E9=80=81: <a href=3D"mailto:hannes@cmpxchg.org" target=3D"_blank"=
>hannes@cmpxchg.org</a>; Future Zhou(=E5=91=A8=E6=9C=AA=E4=BE=86); Rachel Z=
hang(=E5=BC=B5=E7=91=A9); <a href=3D"mailto:bsingharora@gmail.com" target=
=3D"_blank">bsingharora@gmail.com</a>; <a href=3D"mailto:kamezawa.hiroyu@jp=
.fujitsu.com" target=3D"_blank">kamezawa.hiroyu@jp.fujitsu.com</a>; <a href=
=3D"mailto:cgroups@vger.kernel.org" target=3D"_blank">cgroups@vger.kernel.o=
rg</a>; <a href=3D"mailto:linux-mm@kvack.org" target=3D"_blank">linux-mm@kv=
ack.org</a>; <a href=3D"mailto:greg@kroah.com" target=3D"_blank">greg@kroah=
.com</a>
=E4=B8=BB=E9=A2=98: Re: =E7=AD=94=E5=A4=8D: low memory killer

On Thu 20-11-14 10:09:25, <a href=3D"mailto:zhiyuan_zhu@htc.com" target=3D"=
_blank">zhiyuan_zhu@htc.com</a> wrote:
&gt; Hi Michal
&gt; Thanks for your kindly support.
&gt; I got a device, and dump the /proc/meminfo and /proc/vmstat files,=20
&gt; they are the Linux standard proc files.
&gt; I found that: Cached =3D 339880 KB, but nr_free_pages=3D14675*4 =3D 58=
700KB=20
&gt; and nr_shmem =3D 508*4=3D2032KB
&gt;
&gt; nr_shmem is just a little memory, and nr free pages + nr_shmem is=20
&gt; largely less than Cached.  So why nr_free_pages is largely less than=
=20
&gt; Cached? Thank you.

nr_free_pages refers to pages which are not allocated. Cached referes to a =
used memory which is easily reclaimable so it can be reused should there be=
 a need and free memory drops down. So this is a normal situation. How is t=
his related to the lowmemory killer question posted previously?

[...]
--
Michal Hocko
SUSE Labs

</pre><div class=3D""><div class=3D"h5"><table><tbody><tr><td>CONFIDENTIALI=
TY NOTE : The information in this e-mail is confidential and privileged; it=
 is intended for use solely by the individual or entity named as the recipi=
ent hereof. Disclosure, copying, distribution, or use of the contents of th=
is e-mail by persons other than the intended recipient is strictly prohibit=
ed and may violate applicable laws. If you have received this e-mail in err=
or, please delete the original message and notify us by return email or col=
lect call immediately. Thank you. HTC Corporation</td></tr></tbody></table>=
</div></div></blockquote></div><br></div></div>

--047d7bd761d6c8249205084b020e--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
