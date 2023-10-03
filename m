Return-Path: <cgroups-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684F1E75435
	for <cgroups@archiver.kernel.org>; Tue,  3 Oct 2023 07:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjJCHuz (ORCPT <rfc822;cgroups@archiver.kernel.org>);
        Tue, 3 Oct 2023 03:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjJCHuy (ORCPT
        <rfc822;cgroups@vger.kernel.org>); Tue, 3 Oct 2023 03:50:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2EBAB
        for <cgroups@vger.kernel.org>; Tue,  3 Oct 2023 00:50:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 133C51F37E;
        Tue,  3 Oct 2023 07:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1696319450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mpL2MZ89vHaYp4GQSNxe37VWKUrIXE/JsYNmuc8ljqQ=;
        b=iVrUrmCUncB/cAPvQc4kOyHcY5RqZJFmE+Knhzt0JhJhgC/LyyuD8D42wiM+RJsPGjKWEl
        kmSNVH3S04vf0YmNh5sAB79145bYthQv0Ev4vv1YVeG9obM8dC9Xv6zUJo/iwWZKrggkBF
        4xunNUeM5yZaxhrQhxMlpovKztn14LY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 04DBE132D4;
        Tue,  3 Oct 2023 07:50:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pXiuANrHG2WEIQAAMHmgww
        (envelope-from <mhocko@suse.com>); Tue, 03 Oct 2023 07:50:50 +0000
Date:   Tue, 3 Oct 2023 09:50:49 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Haifeng Xu <haifeng.xu@shopee.com>
Cc:     hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeelb@google.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] memcg, oom: unmark under_oom after the oom killer is
 done
Message-ID: <ZRvH2UzJ+VlP/12q@dhcp22.suse.cz>
References: <20230922070529.362202-1-haifeng.xu@shopee.com>
 <ZRE9fAf1dId2U4cu@dhcp22.suse.cz>
 <6b7af68c-2cfb-b789-4239-204be7c8ad7e@shopee.com>
 <ZRFxLuJp1xqvp4EH@dhcp22.suse.cz>
 <94b7ed1d-9ca8-7d34-a0f4-c46bc995a3d2@shopee.com>
 <ZRF/CTk4MGPZY6Tc@dhcp22.suse.cz>
 <fe80b246-3f92-2a83-6e50-3b923edce27c@shopee.com>
 <ZRQv+E1plKLj8Xe3@dhcp22.suse.cz>
 <9b463e7e-4a89-f218-ec5c-7f6c16b685ea@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b463e7e-4a89-f218-ec5c-7f6c16b685ea@shopee.com>
Precedence: bulk
List-ID: <cgroups.vger.kernel.org>
X-Mailing-List: cgroups@vger.kernel.org

On Thu 28-09-23 11:03:23, Haifeng Xu wrote:
[...]
> >> for example, we want to run processes in the group but those parametes related to 
> >> memory allocation is hard to decide, so use the notifications to inform us that we
> >> need to adjust the paramters automatically and we don't need to create the new processes
> >> manually.
> > 
> > I do understand that but OOM is just way too late to tune anything
> > upon. Cgroup v2 has a notion of high limit which can throttle memory
> > allocations way before the hard limit is set and this along with PSI
> > metrics could give you a much better insight on the memory pressure
> > in a memcg.
> > 
> 
> Thank you for your suggestion. We will try to use memory.high instead.

OK, is the patch still required? As I've said I am not strongly opposed,
it is just that the justification is rather weak.

-- 
Michal Hocko
SUSE Labs
