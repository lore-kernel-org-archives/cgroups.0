Return-Path: <cgroups+bounces-1-cgroups=archiver.kernel.org@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 505A3C25B43
	for <cgroups@archiver.kernel.org>; Mon, 23 Oct 2023 16:41:53 +0000 (UTC)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E41FA28167E
	for <cgroups@archiver.kernel.org>; Mon, 23 Oct 2023 16:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168851A722;
	Mon, 23 Oct 2023 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeXRNUIw"
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BE633C8;
	Mon, 23 Oct 2023 16:41:44 +0000 (UTC)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0849F8E;
	Mon, 23 Oct 2023 09:41:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E6C433C7;
	Mon, 23 Oct 2023 16:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698079302;
	bh=O3zoGBXVfb5WJW2MwxE5HShF9ljYkHcSyGRQbT2KEb8=;
	h=Date:From:To:Subject:From;
	b=YeXRNUIwm2ukIK/Xp2TQdb80JGAHUnPY71Q09TJnOej2KrxYIlxF/metEvCCdxuLJ
	 pHOw7zuNTfL0+BG+q2MSYIpj1zEwKm2bZIJv8CkBPVa5dlEx1hfo2as+qRXHNBLFWm
	 dRV0p/wqdLb0+g+ELazTpdSOZdj+Z/JYCL+JKRlI=
Date: Mon, 23 Oct 2023 12:41:41 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: audit@vger.kernel.org, autofs@vger.kernel.org, 
	backports@vger.kernel.org, ceph-devel@vger.kernel.org, cgroups@vger.kernel.org, 
	dash@vger.kernel.org
Subject: This list is being migrated to new vger infra (no action required)
Message-ID: <20231023-obscurity-bottom-1dc09c@meerkat>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello:

This list is being migrated to the new vger infrastructure. This should be a
fully transparent process and you don't need to change anything about how you
participate with the list or how you receive mail.

There will be a brief delay with archives on lore.kernel.org. I will follow up
once the archive migration has been completed.

Best regards,
Konstantin

