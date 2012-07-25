From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 09/10] slab: slab-specific propagation changes.
Date: Wed, 25 Jul 2012 12:07:00 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1207251206300.3543@router.home>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-10-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1343236025; bh=ZTDbBeBtQhOxdJsuRnHpMRX7yt8kSaH9OWv3pSDtQbU=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=v08XAM73lroxcwAK+xsik5Cch3IrCP+JcJWTlUpaw3xkD+agJAF1TbmGnfzpvu9kfj9g/3lslbiFayNkWp72VmqIfa7d+9rJtDXZSRS9ZfaCfI/JMk6+gggVSJ4+/gpEaxDk+6+S0vV4ybvj3to7w/qQf+DcMy2/EbxGnIjaZUw=
In-Reply-To: <1343227101-14217-10-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org, cgroups@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Suleiman Souhlal <suleiman@google.com>

On Wed, 25 Jul 2012, Glauber Costa wrote:

> When a parent cache does tune_cpucache, we need to propagate that to the
> children as well. For that, we unfortunately need to tap into the slab core.

Slub also has tunables.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
