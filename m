From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v2 3/7] memcg: provide online test for memcg
Date: Fri, 18 Jan 2013 11:43:31 -0800
Message-ID: <50F9A5E3.9000406@parallels.com>
References: <1357897527-15479-1-git-send-email-glommer@parallels.com> <1357897527-15479-4-git-send-email-glommer@parallels.com> <20130118153715.GG10701@dhcp22.suse.cz> <20130118155621.GH10701@dhcp22.suse.cz> <50F9A5B3.8050203@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <50F9A5B3.8050203@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>

On 01/18/2013 11:42 AM, Glauber Costa wrote:
>> And the later patch in the series shows that it is really not helpful on
>> > its own. You need to rely on other lock to be helpful.
> No, no need not.
geee, what kind of phrase is that??

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
