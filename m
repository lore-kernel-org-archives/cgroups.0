From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Date: Sat, 28 Apr 2012 14:31:51 -0700
Message-ID: <20120428213151.GA4586@mtj.dyndns.org>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A36DE.30301@jp.fujitsu.com>
 <20120427204035.GN26595@google.com>
 <CABEgKgrJ68wU-L17zwN4_htX948TNFnLVgts=hFeY7QG3etwCA@mail.gmail.com>
 <20120428020003.GA26573@mtj.dyndns.org>
 <CABEgKgpPXPu3L6oS6+2+dZmcPS=t-ZR7PnCvm0mo8UFeXPHDog@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MfDQ3OklIrsMnWpYFS7YUNyqBAhCLS3BYzp1QkaO0A0=;
        b=yxlv0kTQcohm7P1axCUweQ8qsa59urxMN9yB/Qa6IIKNXfbXo4DulqBkryML/MoU+V
         aByavHatxYzuj2o0upgk4Hs1mfhyvb1ADqwOcpL0mAYzeB4rQGclgOdOBYCa+GZRCQH7
         xw7Y51hNM/OaB5dzw8B2HFqbcpfn1fK30dcrjEIsi+7zlcim6ezbunRYzH/1p8d69gyM
         JGNEmSbGRqZQtAljCAOmXIyayQ7YIcPR3fIctnfgdZ+ySHFIIBcCLNjnRrVdLAKq+0/1
         SYWjy0kx4+tBApwG0vO00VnGfjaqQY200FdDekRxIdkZ+JX8/t5DS/qQsd8566I/pweo
         fMqQ==
Content-Disposition: inline
In-Reply-To: <CABEgKgpPXPu3L6oS6+2+dZmcPS=t-ZR7PnCvm0mo8UFeXPHDog@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Linux Kernel <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

Hello, KAME.

On Sat, Apr 28, 2012 at 06:31:38PM +0900, Hiroyuki Kamezawa wrote:
> > So, IMHO, just making pre_destroy() clean up its own charges and
> > always returning 0 is enough. =A0There's no need to fix up old
> > non-critical race condition at this point in the patch stream. =A0cgr=
oup
> > rmdir simplification will make them disappear anyway.
>
> So, hmm, ok. I'll drop patch 7 & 8. memcg may return -EBUSY in very ver=
y
> race case but users will not see it in the most case.
> I'll fix limit, move-charge and use_hierarchy problem first.

IIUC, memcg can just return 0 when child creation races against
pre_destroy().  cgroup will retry if child exists after pre_destroy()
completion.  If child comes and goes before cgroup checks its
existence, some charges may be lost but that race already exists and
it will be gone once the retry logic is removed.  Also, returning
-errno will trigger WARN_ON() w/o the legacy behavior flag.

Thank you very much.

--=20
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter=
.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
