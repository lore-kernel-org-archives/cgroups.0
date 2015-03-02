From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Mon, 2 Mar 2015 10:29:24 -0500
Message-ID: <20150302152924.GD17694@htj.duckdns.org>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
 <1424882288-2910-3-git-send-email-riel@redhat.com>
 <54EEFE15.3010005@huawei.com>
 <20150226121231.6fcba7e8@annuminas.surriel.com>
 <20150302090933.GH21418@twins.programming.kicks-ass.net>
 <1425300290.5863.17.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2uVzzSTOs62ohLxEkd4DhKukHvLemBo1EEBWo6L3YfU=;
        b=JPgCrmojM37c4Pz+iEPxmwKn5ENOcvVnuQD/c4nZeXQ2g9Eb4DmPTWZKe50FfWz8cb
         YXxQ8P8kjv5zv3gIPtsQoZvYvIOYGjghwkKzy4hWlgHE5PLAyFNgKBRZ3oE2O7KQ3D86
         I5FWStX0vsgoBV8wDYb/UCNaHRNOXGoUbtFxAQRHM3rplxIZhBGPjeuQ88Tk5dR6WUAV
         tXcUOLUlNcWl9S5mD7MstKlmJwqDRJIn/jeWT9h+A2IRhL/DZK/hcL7Ge5G7jLJBlfKW
         CPgaNtJ3tlzKcDyGGw2RI8PCaBO1H0uKvP1HgM/U126rv1xn4EsHtdjv46v2/Wk3NuiP
         QDyg==
Content-Disposition: inline
In-Reply-To: <1425300290.5863.17.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 02, 2015 at 01:44:50PM +0100, Mike Galbraith wrote:
> Hm, I'm now all system-disease-ified now (still hate the bloody thing),
> and have no problem isolating cpus via cpusets, modulo workqueues
> wanting a bat upside the head.

It shouldn't be difficult to teach workqueue pools to follow the same
rules.  This matters only for the unbound ones anyway, right?

Thanks.

-- 
tejun
