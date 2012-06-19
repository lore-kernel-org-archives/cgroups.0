From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: add per cgroup dirty pages accounting
Date: Tue, 19 Jun 2012 22:31:35 +0800
Message-ID: <CAFj3OHXuX7tpDe4famK3fFMZBcj2w-9mDs9mD9P_-SwaRKx8tg@mail.gmail.com>
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com>
	<1339761717-29070-1-git-send-email-handai.szj@taobao.com>
	<xr93k3z8twtg.fsf@gthelen.mtv.corp.google.com>
	<4FDC28F0.8050805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=lTfDgwWtwWMGfR1Fm0CQxxh/c8kwZCuxbV5V7OLd3YA=;
        b=Ry21rS6g7mUS2PpP5rbB7oW6QCfiyPKecoCbImNmKexc2PQ3u2RCqCfIGyN4Psihvx
         dkCP1IFodQojeBeVqmj6TycRMVkOFlB4l6szWSJmDbzyBZcy1d/U0sXD5wQC6D/oOjFW
         vZ6HWKq7SNeKXc/LuLHTidZVY1KAbUhUoijVIkMMCavVgrNeFaDmvZ5LW6tu6xmKLPus
         Bsp8AP0ufS3MsrqtXOCsTuwaJIGWSf/SSe8YG7u0zpEOeQ6vNHvdj9ZNJFrN07zt/LnI
         m/JaQiJ4/RaHgRCLnnNifRed9WyT6o96bowvUnOsA/9RfekQvQU3aajMVtNrIBrYzD1p
         ljbg==
In-Reply-To: <4FDC28F0.8050805-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Sat, Jun 16, 2012 at 2:34 PM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2012/06/16 0:32), Greg Thelen wrote:
>>
>> On Fri, Jun 15 2012, Sha Zhengju wrote:
>>
>>> This patch adds memcg routines to count dirty pages. I notice that
>>> the list has talked about per-cgroup dirty page limiting
>>> (http://lwn.net/Articles/455341/) before, but it did not get merged=
=2E
>>
>>
>> Good timing, I was just about to make another effort to get some of
>> these patches upstream. =A0Like you, I was going to start with some =
basic
>> counters.
>>
>> Your approach is similar to what I have in mind. =A0While it is good=
 to
>> use the existing PageDirty flag, rather than introducing a new
>> page_cgroup flag, there are locking complications (see below) to han=
dle
>> races between moving pages between memcg and the pages being {un}mar=
ked
>> dirty.
>>
>>> I've no idea how is this going now, but maybe we can add per cgroup
>>> dirty pages accounting first. This allows the memory controller to
>>> maintain an accurate view of the amount of its memory that is dirty
>>> and can provide some infomation while group's direct reclaim is wor=
king.
>>>
>>> After commit 89c06bd5 (memcg: use new logic for page stat accountin=
g),
>>> we do not need per page_cgroup flag anymore and can directly use
>>> struct page flag.
>>>
>>>
>>> Signed-off-by: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>> ---
>>> =A0include/linux/memcontrol.h | =A0 =A01 +
>>> =A0mm/filemap.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
>>> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 32 ++++++++++++++++=
+++++++++-------
>>> =A0mm/page-writeback.c =A0 =A0 =A0 =A0| =A0 =A02 ++
>>> =A0mm/truncate.c =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01 +
>>> =A05 files changed, 30 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.=
h
>>> index a337c2e..8154ade 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -39,6 +39,7 @@ enum mem_cgroup_stat_index {
>>> =A0 =A0 =A0 =A0MEM_CGROUP_STAT_FILE_MAPPED, =A0/* # of pages charge=
d as file rss */
>>> =A0 =A0 =A0 =A0MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out =
*/
>>> =A0 =A0 =A0 =A0MEM_CGROUP_STAT_DATA, /* end of data requires synchr=
onization */
>>> + =A0 =A0 =A0 MEM_CGROUP_STAT_FILE_DIRTY, =A0/* # of dirty pages in=
 page cache */
>>> =A0 =A0 =A0 =A0MEM_CGROUP_STAT_NSTATS,
>>> =A0};
>>>
>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>> index 79c4b2b..5b5c121 100644
>>> --- a/mm/filemap.c
>>> +++ b/mm/filemap.c
>>> @@ -141,6 +141,7 @@ void __delete_from_page_cache(struct page *page=
)
>>> =A0 =A0 =A0 =A0 * having removed the page entirely.
>>> =A0 =A0 =A0 =A0 */
>>> =A0 =A0 =A0 =A0if (PageDirty(page)&& =A0mapping_cap_account_dirty(m=
apping)) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mem_cgroup_dec_page_stat(page,
>>> MEM_CGROUP_STAT_FILE_DIRTY);
>>
>>
>> You need to use mem_cgroup_{begin,end}_update_page_stat around criti=
cal
>> sections that:
>> 1) check PageDirty
>> 2) update MEM_CGROUP_STAT_FILE_DIRTY counter
>>
>> This protects against the page from being moved between memcg while
>> accounting. =A0Same comment applies to all of your new calls to
>> mem_cgroup_{dec,inc}_page_stat. =A0For usage pattern, see
>> page_add_file_rmap.
>>
>
> If you feel some difficulty with mem_cgroup_{begin,end}_update_page_s=
tat(),
> please let me know...I hope they should work enough....
>

Hi, Kame

While digging into the bigger lock of mem_cgroup_{begin,end}_update_pag=
e_stat(),
I find the reality is more complex than I thought. Simply stated,
modifying page info
and update page stat may be wide apart and in different level (eg.
mm&fs), so if we
use the big lock it may lead to scalability and maintainability issues.

=46or example:
     mem_cgroup_begin_update_page_stat()
     modify page information                 =3D> TestSetPageDirty in
ceph_set_page_dirty() (fs/ceph/addr.c)
     XXXXXX                                         =3D> other fs opera=
tions
     mem_cgroup_update_page_stat()   =3D> account_page_dirtied() in
mm/page-writeback.c
     mem_cgroup_end_update_page_stat().

We can choose to get lock in higher level meaning vfs set_page_dirty()
but this may span
too much and can also have some missing cases.
What's your opinion of this problem?


Thanks,
Sha
