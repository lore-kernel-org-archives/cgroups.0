From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 3/4] memcg: add per cgroup writeback pages accounting
Date: Sat, 24 Aug 2013 00:11:50 +0800
Message-ID: <CAFj3OHUqv9d_0x6hMkboox=B3rPeSe5QJq_ztV+zisuymsjLdw@mail.gmail.com>
References: <CAFj3OHXy5XkwhxKk=WNywp2pq__FD7BrSQwFkp+NZj15_k6BEQ@mail.gmail.com>
	<1377165190-24143-1-git-send-email-handai.szj@taobao.com>
	<20130822154002.ce4310d865ede3a0d30f0ce8@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=IfUd+8DhrnL8M+2ibbPSEfel6cN3BwFolmochOQNyBQ=;
        b=Qk2cDRFWy1qGbqrecE28I2mh5VblT5qGInNCfXos9S+NIqrL3ZZ5wE/Sa5NMqs+oar
         hRQwXUTnKsSKTlJUWBv92mAItx+E1Jf6lgUDaC6qTDW994rD3PPHnlQviUvafjF3AyPe
         Tvp1aV52F9HQ9HWcAcgWsawZ0ZszQAxTWqTWcVvvo8PA85fAwUisDkiS9csbwitfvrBJ
         1aFo7jsA9mCpQqufui7sEUjLWp1bMIlwrJfcV1FO0Jk+52sDSRpIenMuICsJ55yBCxKN
         ovamsZjoZD64Ppuvc0Z7LOipS1k+xUVb9vmykyQrcEyfjBfXB3UgCT2CX2Ct5s2SPzcb
         ls6A==
In-Reply-To: <20130822154002.ce4310d865ede3a0d30f0ce8@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Greg Thelen <gthelen@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Sha Zhengju <handai.szj@taobao.com>

On Fri, Aug 23, 2013 at 6:40 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 22 Aug 2013 17:53:10 +0800 Sha Zhengju <handai.szj@gmail.com> wrote:
>
>> This patch is to add memcg routines to count writeback pages
>
> Well OK, but why?  What use is the feature?  In what ways are people
> suffering due to its absence?

My apologies for not explaining it clearly.

It's subset of memcg dirty page accounting(including dirty, writeback,
nfs_unstable pages from a broad sense), which can provide a more sound
knowledge of memcg behavior. That would be straightforward to add new
features like memcg dirty page throttling and even memcg aware
flushing.
However, the dirty one is more complicated and performance senstive,
so I need more efforts to improve it and let the writeback patch go
first.  Afterwards I'll only focus on dirty page itself.

-- 
Thanks,
Sha
