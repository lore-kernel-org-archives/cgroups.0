From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch 2/8] mm: unify remaining mem_cont, mem, etc. variable
 names to memcg
Date: Mon, 28 Nov 2011 06:12:17 +0530
Message-ID: <CAKTCnzmO6P1B_8kGG5tPOrWAb6PT0byOZ4WQdfWwbaHAX7shww@mail.gmail.com>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=X28Abgfdpqq2xRx4nvuwg6f5i7TkdE+RKkHGtL2kEaU=;
        b=m2thWjwBeWC/diaTWnxuWOgIhy+zjzit+Lblqv+o5jOz4TChtdeZvo1uyM5l3ZfkuG
         h3d0UzhkOtNsom7jlLer1aPFRkG5CeDq1y+L8ZK7zUUuBbP1wU6oC5TkxZ32yXbTPcbL
         fcksgmT81kaDA3xg3agZTLshp1XxVi1v9cRFQ=
In-Reply-To: <1322062951-1756-3-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:12 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> From: Johannes Weiner <jweiner@redhat.com>
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>


I am not very comfortable with memcgp, I'd prefer the name to
represent something more useful especially when it is an output
parameter. Having said that I don't think it is a stopper for the
patch

Balbir Singh.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
