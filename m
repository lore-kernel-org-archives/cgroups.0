From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix return child memcg objcg for root
 memcg
Date: Wed, 28 Oct 2020 17:16:35 -0700
Message-ID: <20201029001635.GG827280@carbon.dhcp.thefacebook.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Wezy4DYR5kvzfw0GSzM0X3/leEpFzBtL5X/O9Zeyxko=;
 b=SscM3TDBZWuMkz3Obak3AvOpVvnXdSXywpBNgsYMkW6aX+DM9J7mEfavbwsH7vbEunlL
 XXsaSGObuAIkpfLRKp6Yuv07cRQgN3IhDQC/B9ZPt/s3PvkpKBDxbNUCkVoF0br8IJNp
 v03AR9ZsN9NQf2Cxv9w0EeVU3o6hiQURASc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wezy4DYR5kvzfw0GSzM0X3/leEpFzBtL5X/O9Zeyxko=;
 b=WYpHDni9tTu12RxILlCuUr01baxJbhEhVyEefgaKu8mCB+4aZuEQeGi+msyX9/DndLCTnmsqslWCebFiO2TMMNiOkp5dLizqobX+bKQhfDM4eejkX3oI1ln8Rzy/4JBMGo9Kv7Fgheyc83adHa7hRtPWLxCndKtEdUK+h3MZS3s=
Content-Disposition: inline
In-Reply-To: <20201028035013.99711-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, Oct 28, 2020 at 11:50:10AM +0800, Muchun Song wrote:
> Consider the following memcg hierarchy.
> 
>                     root
>                    /    \
>                   A      B
> 
> If we get the objcg of memcg A failed, the get_obj_cgroup_from_current
> can return the wrong objcg for the root memcg.
> 
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
