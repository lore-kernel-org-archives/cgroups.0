From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/2] memcg, fsnotify: no oom-kill for remote memcg charging
Date: Mon, 29 Apr 2019 23:32:42 -0400
Message-ID: <CALvZod5uXOQfeq9_03T5dv104tWwuukL0+vEAVhk-v1_A=skQQ@mail.gmail.com>
References: <20190429171332.152992-1-shakeelb@google.com> <20190429171332.152992-2-shakeelb@google.com>
 <20190429214123.GA3715@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWEKtGsRIMq4v+NhZemcUNWB8/vTGODLsuHGIZCvLns=;
        b=DDDpEVSRE8oPO+cOinkkQ7lINMkV8y8Sp8Tp7Uttz0QF6r5bQ6+/3ePMNmPLDpz7rI
         KPala0XBYAmQ3SePPZ40hYTg86geNQPy2Grc0K4z4RE6whwqluCHezd1NGgB6rfucnUg
         hV0HXKuk9r2hCL9OuhfjFrDv44ufG3YiG18/uldGmxv/21HyO0kCQVr3yLGsWLB7fOC3
         SkopmmTFkLYAnVdS9QIFL6GJf2lX9LAxqwQPzB+5TwzDX+vkYdax3NVP1fpz6XxoBOlo
         7+1lZvseE7ID/p1TWU21NN5jMaEzewo6ONCu/nBDNYNpYsDUS9LKTnK702xr83iKOnNl
         XqIA==
In-Reply-To: <20190429214123.GA3715@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Apr 29, 2019 at 5:41 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 29-04-19 10:13:32, Shakeel Butt wrote:
> [...]
> >       /*
> >        * For queues with unlimited length lost events are not expected and
> >        * can possibly have security implications. Avoid losing events when
> >        * memory is short.
> > +      *
> > +      * Note: __GFP_NOFAIL takes precedence over __GFP_RETRY_MAYFAIL.
> >        */
>
> No, I there is no rule like that. Combining the two is undefined
> currently and I do not think we want to legitimize it. What does it even
> mean?
>

Actually the code is doing that but I agree this is not documented and
weird. I will fix this.

Shakeel
