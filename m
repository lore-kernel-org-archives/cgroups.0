From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch 3/8] mm: memcg: clean up fault accounting
Date: Mon, 28 Nov 2011 06:15:05 +0530
Message-ID: <CAKTCnzkaWAnpbz+o3G=-mO1qUYKVjXaJwcCDYYt0SCspJdbe3g@mail.gmail.com>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=RoDYdZhLeS+cT9WjoFtmSDo6hGQ4PP+2qus+1Aqpesw=;
        b=lz/VuY5U7+RExTzAqaODXt18mFz57zpUEhW6R7FZp/LWzurFZnZxSX/eSC1f8n/PMf
         wnq3LpNcYRIIv+hyFWBov5gD5XvHTwsJWFdi3cD3jg3MVUgFhjII3fu+85DXRKlUPEXR
         ssFeqEiqrDCryfOC3oiI3ATuL/Pu/2tNRg1HY=
In-Reply-To: <1322062951-1756-4-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote=
:
> From: Johannes Weiner <jweiner@redhat.com>
>
> The fault accounting functions have a single, memcg-internal user, so
> they don't need to be global. =A0In fact, their one-line bodies can be
> directly folded into the caller. =A0And since faults happen one at a
> time, use this_cpu_inc() directly instead of this_cpu_add(foo, 1).
>

Acked-by: Balbir Singh <bsingharora@gmail.com>

Balbir Singh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
