From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 3/5] change number_of_cpusets to an atomic
Date: Tue, 24 Apr 2012 10:02:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1204241001050.26005@router.home>
References: <1335209867-1831-1-git-send-email-glommer@parallels.com> <1335209867-1831-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1335279724; bh=u+uQiAEjSxHXOgnixE3OgW5J0uiyFMEtrq3nhynypIQ=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=C+LYQGMaNbcZPSusAjMBQZ/MefN2n/bHmxmsclX+w7x8BVmSsq4FXZi68o3RYTHA5VJujE1m3n17kKpIWWYnhVg5p2yGX6zgJXt/2m3OT7eCeQcmMU0uUVb017z2d5gRnPMadcFI0acG28N6Atumy6dvjHhRSIfYfghpxkJocIE=
In-Reply-To: <1335209867-1831-4-git-send-email-glommer@parallels.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>, netdev@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, kamezawa.hiroyu@jp.fujitsu.com, David Miller <davem@davemloft.net>, devel@openvz.org

On Mon, 23 Apr 2012, Glauber Costa wrote:

> This will allow us to call destroy() without holding the
> cgroup_mutex(). Other important updates inside update_flags()
> are protected by the callback_mutex.
>
> We could protect this variable with the callback_mutex as well,
> as suggested by Li Zefan, but we need to make sure we are protected
> by that mutex at all times, and some of its updates happen inside the
> cgroup_mutex - which means we would deadlock.

Would this not also be a good case to introduce static branching?

number_of_cpusets is used to avoid going through unnecessary processing
should there be no cpusets in use.
