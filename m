From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
Date: Wed, 9 Jan 2013 14:04:06 -0800
Message-ID: <20130109220406.GE20454@htj.dyndns.org>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
 <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
 <20130109203731.GA20454@htj.dyndns.org>
 <50EDDF1E.6010705@parallels.com>
 <20130109213604.GA9475@lizard.fhda.edu>
 <20130109215514.GD20454@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=tAbsA1Ee9yqUF5KhySRuEigTWXZyQdXF7O3MkNcL91g=;
        b=UiUEnJNpEGekoUii6JsXKpEpCGg4bdztKuXlnmoQsTZ0N2xzBZRmqurSoj98Z954Ti
         Fbb68bZesKo9N3WvYsvDa+IDdtGSyjMbysw0L2qEkCh4Dy43UwW/PItc00eSjOFcZiGL
         3x4G5+NtDmLehT/ld2q1Gwdd+FV7XAID0eX+nviGWdCJ9BM0sOx5wGlQ48ls1JNFUEZu
         qIgQSx99tA53JRMuN0SnrgRdubYVy9ty5OYh/Ox0ceHzpXsSVofllLjMHTlnbaT0kZaY
         BxOZTPR0B9eohvutUgEj6qTFI1tnYSCfVQ5VmJB1SqutglL7IsFD0lvXwvLUelkt1mGI
         6ohA==
Content-Disposition: inline
In-Reply-To: <20130109215514.GD20454@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Glauber Costa <glommer@parallels.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Luiz Capitulino <lcapitulino@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Leonid Moiseichuk <leonid.moiseichuk@nokia.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Minchan Kim <minchan@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org, patches@linaro.org, kernel-team@android.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Wed, Jan 09, 2013 at 01:55:14PM -0800, Tejun Heo wrote:
> Please talk with memcg people and fold it into memcg.  It can (and
> should) be done in a way to not incur overhead when only root memcg is
> in use and how this is done defines userland-visible interface, so
> let's please not repeat past mistakes.

CC'ing KAMEZAWA, Johannes, Li and cgroup mailing list.  Please keep
them cc'd for further discussion.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
