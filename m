From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC] slub: show dead memcg caches in a separate file
Date: Tue, 8 May 2012 08:42:04 +0300
Message-ID: <CAOJsxLHFS+B64qfhCg-9LPbggPoyvkBSnA8nZPRoV15eeRpi_w@mail.gmail.com>
References: <1336070841-1071-1-git-send-email-glommer@parallels.com>
	<CABCjUKDuiN6bq6rbPjE7futyUwTPKsSFWHXCJ-OFf30tgq5WZg@mail.gmail.com>
	<4FA89348.6070000@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=E/arSZKRzDhM8VRlGvxj7CaA7ccYr8t6HsnFoMkDb4U=;
        b=ehsh1VE71RONKcTFn5lJil7iQp7lFFRb2+EJ+WrZgk+HUHrjbqGWR+yosyXjU8OTjL
         6alUfnFdniedvzRu+m2zFN4R+JGqD7fLbUL2fuiPKhT+g9KTXWkaWGfHMVU7WZ11O7We
         WxEkNkJpK+oAnk5ZiK3HxHM/uewjNC52N4WXzDx/kRbKuQuIFxSmzfZMoCV8VsKe73/x
         bgqsECmzM5m6huoZ4ljCcIPv6U6y+trC5t42cY1HkgGFRmjA1qVsTHwlqXtb86uMecnE
         qM79Mb0Do1AoqcH4w4ZnQ5y0GNz2JVmowxlfVeH8qD+mcz/Ed4JKWOPGWshHiZFrmdbE
         9WEw==
In-Reply-To: <4FA89348.6070000@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Suleiman Souhlal <suleiman@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, devel@openvz.org, Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.cz>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>

On Tue, May 8, 2012 at 6:30 AM, Glauber Costa <glommer@parallels.com> wrote:
> But there is another aspect: those dead caches have one thing in common,
> which is the fact that no new objects will ever be allocated on them. You
> can't tune them, or do anything with them. I believe it is misleading to
> include them in slabinfo.
>
> The fact that the caches change names - to append "dead" may also break
> tools, if that is what you are concerned about.
>
> For all the above, I think a better semantics for slabinfo is to include the
> active caches, and leave the dead ones somewhere else.

Can these "dead caches" still hold on to physical memory? If so, they
must appear in /proc/slabinfo.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
