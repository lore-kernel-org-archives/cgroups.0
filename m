From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v11 00/25] shrinkers rework: per-numa, generic lists,
 etc
Date: Fri, 7 Jun 2013 10:11:09 +0400
Message-ID: <51B1797D.3010209@parallels.com>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org> <20130606141501.72d80a9a5c7bce4c4a002906@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130606141501.72d80a9a5c7bce4c4a002906@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com

On 06/07/2013 01:15 AM, Andrew Morton wrote:
> On Fri,  7 Jun 2013 00:34:33 +0400 Glauber Costa <glommer@openvz.org> wrote:
> 
>> Andrew,
>>
>> I believe I have addressed most of your comments, while attempting to address
>> all of them. If there is anything I have missed after this long day, let me
>> know and I will go over it promptly.
> 
> I'll trust you - I've had my fill of costacode this week ;)
> 
In all fairness, since I have just sent the first part of the series,
most of it is still davecode.

> Can you send over a nice introductory [patch 0/n] as an overview of the
> whole series?
>
Sure. I will do shortly, as soon as I get to my office.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
