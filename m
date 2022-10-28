From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: Simplify code in css_set_move_task
Date: Fri, 28 Oct 2022 19:29:57 +0800
Message-ID: <adb7418c-39a2-6202-970a-a039ad8201dd@shopee.com>
References: <20221020074701.84326-1-haifeng.xu@shopee.com>
 <20221027080558.GA23269@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yu+lIBqvdWX/8opgIO5TCCOvdjg6GfRL6HZjYwfiOzc=;
        b=KFdR4DrR4ZOHgalVT1ZZZrYTnZc2T3Qy3ciD2uuPVHkcSjQ4oL1D4Rf1eiub+pAGWC
         /tWIGLcYkwUahSp514zz4CKbcYhV98oOhJntKtlyKlJmpoUDovKaNz4QMOhTx9CO7PY5
         TLMjcqafDfsimAbPNjrOdsQhllqBzDHZ4t4cZAvxCUQQ2H+bUar16qV/ywySARZwQhtk
         5BchDQZs2qbzLZ/mCpBaXyIn78Hli9583C+G5VXTLrr65bnIjXteahFNbjemB2dxgfrr
         AlsvXwG0w0dTKu/1u6w+ZVCmwBrEaW22ysWCzY+3chrun+iIZ7XfFSrqPR6vu394uNmG
         HgpQ==
In-Reply-To: <20221027080558.GA23269-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2022/10/27 16:05, Michal Koutn=C3=BD wrote:
> Hello.
>=20
> On Thu, Oct 20, 2022 at 07:47:01AM +0000, "haifeng.xu" <haifeng.xu-LL2PKP=
oSiP3QT0dZR+AlfA@public.gmane.org> wrote:
>> -	lockdep_assert_held(&css_set_lock);
>> +	if (!cset || cset is either getting the first task or losing the last(=
cset))
>> +		return;
>=20
> 1) the guard should be css_set_populated() ^ populated (when unsetting
> the populated trait)
>=20
> 2) I'd keep the lockdep_assert_held() after it anyway.
>=20
> Also the commit message should explain what's the reason to move
> css_set_populated() after css_set_move_task().
>=20
>=20
> Thanks,
> Michal
Hi, Michal.

1) If calls 'css_set_update_populated' , the cset is either getting the
first task or losing the last. There is a need to update the populated
state of the cset only when 'css_set_populated' returns false.
In other words, the last has been deleted from from_cset and the first
hasn't been added to to_cset yet.

2) Thanks for your suggestion. I'll keep 'lockdep_assert_held'.

3) In order to update the populated state of to_cset the same way
from_cset does, 'css_set_update_populated' is also invoked during the
process of moving a task to to_cset.

Thanks,
Haifeng
