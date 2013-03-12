From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
Date: Tue, 12 Mar 2013 06:34:46 -0700
Message-ID: <20130312133446.GA3514@kroah.com>
References: <513ECCFE.3070201@huawei.com>
 <20130312101555.GB30758@dhcp22.suse.cz>
 <20130312110750.GC30758@dhcp22.suse.cz>
 <20130312130504.GD30758@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=x-received:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=636X8Q7OfmQ6obMB7I+RMjweEvJH1mmsf7J/j9AU1y4=;
        b=amBe0+tPvT4fxPg1/lYWDFF6QdnTL90/ItjpmaAv7oE3+n0DuFlywNKMUK+uUgNg+f
         n+sx6b9cxx4UMVEF/qs6icq7Z8zel+wPKW4QW8AVY7sc1QG/cdVlQ/6lJRC2//CwPoxc
         WSvCWm1EfLbLH7ohlmC1kSniCsRN1cfYzdlOc=
Content-Disposition: inline
In-Reply-To: <20130312130504.GD30758@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>

On Tue, Mar 12, 2013 at 02:05:04PM +0100, Michal Hocko wrote:
> The fix is quite simple. We can pull the key inside bus_type structure
> because they are defined per device so the pointer will be unique as
> well. bus_register doesn't need to be a macro anymore so change it
> to the inline. We could get rid of __bus_register as there is no other
> caller but maybe somebody will want to use a different key so keep it
> around for now.

Nice work, but just drop __bus_register(), no one should need to use a
new key for this type of thing, now that you have added a per-bus_type
variable.

thanks,

greg k-h

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
