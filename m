From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 9 Jul 2013 07:42:59 -0700
Message-ID: <20130709144259.GF2478@htj.dyndns.org>
References: <20130708175201.GB9094@redhat.com>
 <20130708175607.GB18600@mtj.dyndns.org>
 <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
 <20130709134558.GD2478@htj.dyndns.org>
 <51DC1FCA.3060904@openvz.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jVTK/3DfwnFR6mbxMw/hdwL5qNLYqSWFXdqwH1eEkzs=;
        b=KO7m7w42iPBMohUt8sHiE5fjCH40IJuoApYeqOGR86TGijJM9eeq/ymtVD1lCdn5EZ
         ds4SjtXRfZ5AWyDxXW0w2ssx+KgxkFU9JBO4jgdS9uZkD2u8+mHpyTWw0nnpALolKCXY
         vUG9qIxFi0tn3wVRsratN2pcrX09GAlbTUKWHFHtoIC77+TZklHeUOSqHnlKC60PSoFr
         SVysqhYexLiC1thu5npGZR0EI6e1TQbdXHkrhg6IIJMBTMJ0nWGOjcVcD56PjFyUUggN
         MB8QCgWr+Rd7+8iVKYAkPhf6rrzaRGcCiZasC5kHifZk1U61N8/RK6ROwXx4q06HFQEC
         oxOw==
Content-Disposition: inline
In-Reply-To: <51DC1FCA.3060904@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

On Tue, Jul 09, 2013 at 06:35:54PM +0400, Konstantin Khlebnikov wrote:
> I'm not interested in QoS or proportional control. Let schedulers do it.
> I want just bandwidth control. I don't want to write a new scheduler

Well, I'm not interested in adding more half-assed stuff on top of the
existing mess.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
