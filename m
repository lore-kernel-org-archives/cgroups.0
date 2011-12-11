From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] make clone_children a flag
Date: Sun, 11 Dec 2011 15:48:50 +0100
Message-ID: <4EE4C2D2.9090402@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323614738-7405-2-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, jbottomley@parallels.com, cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org

On 12/11/2011 03:45 PM, Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if the clone_children flag is set.
> Make it a flag
>
> Signed-off-by: Glauber Costa<glommer@parallels.com>

This one is repeated, I don't know how it went through. Sorry.
