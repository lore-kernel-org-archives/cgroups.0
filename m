From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH -V8 02/16] hugetlb: don't use ERR_PTR with VM_FAULT* values
Date: Sat, 9 Jun 2012 15:28:21 -0400
Message-ID: <CAHGf_=oPLXvgPzeAn0Cn5Pni0NrdOzZ=hNTmAg5QACCzuv7z9A@mail.gmail.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=YbociPc5LByiRA5UIVMZmWmlBgfD5ARCYI+PqLFoUDw=;
        b=vwTVof6kcAsTdks6DYZA/3898S6xsvAKf7wO+hajt2e75FaMdFl3x9rrmrkgAo5IvJ
         HSYKuE09Xpa2uzmoTl0WZNmQuyqVZszrspywKTFg5b/N4lOci382nWxffR4YT+xEg6CW
         FL45IzCir8mAQ9k37RqQl6+dFtROLQVHACnng8OtVOTwyQ9xZYZkutPGj5bi63GVI8tH
         SMeSw36qdrgqh39piI18Ubkb+IREbEmILYZIgIbNrIQ6XbCRdHQBxwZQkJEETRLTD01i
         A4aM1POdCunRJyuUay9R5Sjfmsm5nFgJ+46El9mFZowFt5oj9brYi2KaAXoDw01dcJ9I
         qOcg==
In-Reply-To: <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sat, Jun 9, 2012 at 4:59 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>
> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> VM_FAULT_* values will not exceed MAX_ERRNO value. Decouple the
> VM_FAULT_* values from MAX_ERRNO.
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I like this much.

 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
