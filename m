From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] memcg, fsnotify: no oom-kill for remote memcg charging
Date: Wed, 8 May 2019 23:20:51 +0000
Message-ID: <20190508232042.GA1104@tower.DHCP.thefacebook.com>
References: <20190504145242.258875-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lCdKIPHMGvGvKmpk8HbdROgwQl29v5EI3TaR7mBLsA0=;
 b=Pew+PYZM1QGT2MtjUHc5cGi8l27SXBbToaK7F9TuFPp3oTTYU+whHtRiRc3QZAO5Zuu1
 O+MxB7AZEYfkVoTz21gowViQXBz1TniDPynF8clJOnKu22xUcpufxvXwEI1iwlx9OTuY
 EKpgc24XYoU+S1doILWUQMg6jkQ4SFtmL9Q= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCdKIPHMGvGvKmpk8HbdROgwQl29v5EI3TaR7mBLsA0=;
 b=MV69l51gbUsBTwbnHJhapq3cSvmtIF6OxMJgTP04A32LqgR4dYeyPH63cZRVrC3GfPJ5P8F/P94ub8sNEEN6CcRQV9xTwmZztlRocVVyOzm3OLkwYjA1daGex7FkEcXwwuqElHkpL3p6Uu049K1vL8/3Gp5MkTrVbw2PHJ3oKTA=
In-Reply-To: <20190504145242.258875-1-shakeelb@google.com>
Content-Language: en-US
Content-ID: <FAA360BA6EA9A646B5F14EE9A945F468@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Sat, May 04, 2019 at 07:52:42AM -0700, Shakeel Butt wrote:
> The commit d46eb14b735b ("fs: fsnotify: account fsnotify metadata to
> kmemcg") added remote memcg charging for fanotify and inotify event
> objects. The aim was to charge the memory to the listener who is
> interested in the events but without triggering the OOM killer.
> Otherwise there would be security concerns for the listener. At the
> time, oom-kill trigger was not in the charging path. A parallel work
> added the oom-kill back to charging path i.e. commit 29ef680ae7c2
> ("memcg, oom: move out_of_memory back to the charge path"). So to not
> trigger oom-killer in the remote memcg, explicitly add
> __GFP_RETRY_MAYFAIL to the fanotigy and inotify event allocations.
>=20
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
> Changelog since v1:
> - Fixed usage of __GFP_RETRY_MAYFAIL flag.
>=20
>  fs/notify/fanotify/fanotify.c        | 5 ++++-
>  fs/notify/inotify/inotify_fsnotify.c | 7 +++++--
>  2 files changed, 9 insertions(+), 3 deletions(-)

Hi Shakeel,

the patch looks good to me!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
