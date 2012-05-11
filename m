From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 02/29] slub: fix slab_state for slub
Date: Fri, 11 May 2012 12:51:10 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205111250590.31049@router.home>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1336758674; bh=W+RMaZd80TznyN1gxiN4nC6UhXA+U2pj3Crww5b78oo=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=g4r4ben5BZlA5aQHIoyI0rmmSNI780yBd6WQARq/jmM4VepT69uqRnax+2AEG6lHk+frZdFwtH2xAi4DdV8nwy6IzHXVMreDHHBRj1uY2Xz3NeBO2cl+qvOGjS5g1GnosDVIT2OKImoE8xIemm4ajpyYn4pWn8Tbx5dVQA6CkMU=
In-Reply-To: <1336758272-24284-3-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>



Acked-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
