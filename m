From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/6] memcg: remove unused variable
Date: Mon, 26 Dec 2011 15:29:41 +0900
Message-ID: <20111226152941.198b6461.kamezawa.hiroyu@jp.fujitsu.com>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
	<1324695619-5537-3-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1324695619-5537-3-git-send-email-kirill@shutemov.name>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-2022-jp"
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

On Sat, 24 Dec 2011 05:00:16 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> mm/memcontrol.c: In function ‘mc_handle_file_pte’:
> mm/memcontrol.c:5206:16: warning: variable ‘inode’ set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

nice.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
